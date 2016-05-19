#!/usr/local/bin/ruby
# coding: utf-8

require 'jpstock'
require './config'

filename = "performance.csv"

csvdatas = CSV.read(CsvPath(filename), "r:utf-8")
for csvdata in csvdatas
  #20分より前のデータを消去
  while csvdata.length > 11 do
    csvdata.slice!(3..4)
  end
  
  #現在のデータを取得
  if csvdata[0] == "コード"
    csvdata.push(Time.now.strftime("%H:%M"),"前日比")
  else
    data = JpStock.quote(:code=>csvdata[0])
    csvdata.push(data.close, ((data.close.to_f/data.prev_close-1)*100).round(2).to_s + "%")
    sleep(SleepTime())
  end
end

# ファイルへ書き込み
CSV.open(CsvPath(filename), "w") do |csv|
  for csvdata in csvdatas
    csv << csvdata
  end
end
