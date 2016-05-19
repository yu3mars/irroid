# irroid
IRroid用ツール

# How to use
config.rb.example をconfig.rbにコピーしたうえで、pathなどをお好みの場所に設定してください。

cronで以下のように定期実行を設定するのがおすすめです。

    55   8    *   *     1-5     ruby  /path/to/your/irroid/ruby/irroid_init.rb
    */5   9-15    *   1-5     *     ruby  /path/to/your/irroid/ruby/irroid.rb
    
# Require
ruby

    gem install jpstock