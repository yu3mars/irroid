#!/usr/local/bin/ruby
# coding: utf-8

require 'jpstock'
require_relative './config'
def MakePricelogCsv()
  pricelogFilename = "pricelog.csv"

  csvdatas = CSV.read(CsvPath(pricelogFilename), "r:utf-8")
  for csvdata in csvdatas
    #20分より前のデータを消去
    while csvdata.length > 7 do
      csvdata.slice!(3)
    end
    
    #現在のデータを取得
    if csvdata[0] == "コード"
      csvdata.push(Time.now.strftime("%H:%M"))
    else
      data = JpStock.quote(:code=>csvdata[0])
      csvdata.push(data.close)
      sleep(SleepTime())
    end
  end

  # ファイルへ書き込み
  CSV.open(CsvPath(pricelogFilename), "w") do |csv|
    for csvdata in csvdatas
      csv << csvdata
    end
  end
end


def MakePerformanceCsv()
  pricelogFilename = "pricelog.csv"
  performanceFilename = "performance.csv"

  csvdatas = CSV.read(CsvPath(pricelogFilename), "r:utf-8")
  for csvdata in csvdatas
    #現在のデータを取得
    if csvdata[0] == "コード"
      for i in 0..csvdata.length-4
        csvdata[4+i*2,0] = "前日比"
      end
    else
      for i in 0..csvdata.length-4
        #前日比の%表示を挿入
        p csvdata[3+i*2]
        p csvdata[3+i*2].to_f
        csvdata[4+i*2,0] = ((csvdata[3+i*2].to_f / csvdata[2].to_f - 1.0) * 100.0).round(2).to_s + "%"
      end
    end
  end

  # ファイルへ書き込み
  CSV.open(CsvPath(performanceFilename), "w") do |csv|
    for csvdata in csvdatas
      csv << csvdata
    end
  end
end



MakePricelogCsv()
MakePerformanceCsv()
