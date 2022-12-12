#!/bin/bash

# パスワード付きZipファイルの生成、Zipファイルのハッシュ値の検証を行う

function usage() {
  echo "usage: create_zip [<args>]"
  echo "  args:"
  echo "    \$1 : zipfile prefix"
  echo "    \$2 : password length"
  exit 1
}

function createPass(){
  cat /dev/urandom | \
  tr -dc '12345678abcdefghijkmnpqrstuvwxyzABCDEFGHIJKLMNPQRSTUVWXYZ,.+!\-' | \
  fold -w "$1" | grep -E '[12345678]' | grep -E '[,\.+\-\!]' | \
  grep -E '^[12345678abcdefghijkmnpqrstuvwxyzABCDEFGHIJKLMNPQRSTUVWXYZ]' | \
  head -n 1
}

# 引数のチェック
ZIP_FILE_PREFIX_NAME=$1
if [ -z "$1" ] ; then usage ; fi

LEN=$2
if [ -z "${LEN}" ] ; then LEN=10 ; fi

# フォルダが存在しない場合は、そのフォルダを作成する
if [ ! -d "output" ]; then
  mkdir "output"
else
 rm -r ./output/*
fi

if [ ! -d "tmp" ]; then
  mkdir "tmp"
else
  rm -r ./tmp/*
fi

# ファイルごとにパスワード付きzipファイルを作成する
FILE_LIST=$(find ./input -type f)
for path in ${FILE_LIST[@]}
do
  echo "start--------------------------"
  password=$(createPass $LEN)
  FILE_NAME=$(echo "$path" | cut -f 3 -d "/")
  ZIP_FILE_NAME="$ZIP_FILE_PREFIX_NAME"_"$(echo "$FILE_NAME" | cut -f 1 -d "." ).zip"

  echo "filename: $FILE_NAME"
  echo "zip file name: $ZIP_FILE_NAME"
  echo "password: $password"

  # Git Bashにzipコマンドがないため、7zコマンド(7zipのコマンドライン)を使用して圧縮
  echo "$(date) -----------------------" >> result.txt
  7z a -p$password "output/$ZIP_FILE_NAME" "$path" >> result.txt

  # zipファイルを解凍して、オリジナルファイルとハッシュ値を比較
  7z x -o./tmp -p"$password" "output/$ZIP_FILE_NAME" >> result.txt
  echo "-----------------------------------------------" >> result.txt
  hash1="$( sha256sum "input/$FILE_NAME" | cut -f 1 -d " " )"
  hash2="$( sha256sum "tmp/$FILE_NAME" | cut -f 1 -d " " )"
  echo "SHA-256"
  echo "  input: $hash1"
  echo "  tmp  : $hash2"
  if [ "$hash1" == "$hash2" ]
  then
      echo "  OK"
  else
      echo "  NG"
  fi
  echo "end--------------------------"
done

