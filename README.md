# 概要
inputフォルダ配下のファイルをそれぞれパスワード付きzipファイルに圧縮する．

作成後のzipファイルを解凍し，解凍後のファイルと元のオリジナルのファイルのハッシュ値を比較する．

# 使い方

- inputフォルダ配下にパスワード付きzipファイルにしたいファイルを格納する（複数可）
- zipファイル名のprefixを引数に設定し，実行する
  `./create_zip.sh "テスト"`

# 例

~~~
$ ls input/
sample001.txt  sample002.html

$ ./create_zip.sh "テスト"
start--------------------------
filename: sample001.txt
zip file name: テスト_sample001.zip
password: Y1R7B2RL+,
SHA-256
  input: 8151aa7be4d8aa304f81bea154a7d92180f02a2eab00f673fc53b2ba84070b01
  tmp  : 8151aa7be4d8aa304f81bea154a7d92180f02a2eab00f673fc53b2ba84070b01
  OK
end--------------------------
start--------------------------
filename: sample002.html
zip file name: テスト_sample002.zip
password: PVmN5u!Zp,
SHA-256
  input: 8566994174e2cbe9327dd61a8be0a78fb0acfe9b8bb586e839ce51008f3578cb
  tmp  : 8566994174e2cbe9327dd61a8be0a78fb0acfe9b8bb586e839ce51008f3578cb
  OK
end--------------------------

$ ls output/
テスト_sample001.zip  テスト_sample002.zip
~~~



# 補足
- 引数にパスワードの桁数を設定可能
~~~
usage: create_zip [<args>]
  args:
    $1 : zipfile prefix
    $2 : password length
~~~


