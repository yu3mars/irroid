#!/usr/local/bin/ruby
# coding: utf-8

require 'jpstock'
require_relative './config'

def MakePricelogCsv()
  csvdatas = CSV.read(PricelogFilename(), "r:utf-8")
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
  CSV.open(PricelogFilename(), "w") do |csv|
    for csvdata in csvdatas
      csv << csvdata
    end
  end
end


def MakePerformanceCsv()
  csvdatas = CSV.read(PricelogFilename(), "r:utf-8")
  for csvdata in csvdatas
    #前日比の%表示を挿入
    if csvdata[0] == "コード"
      for i in 0..csvdata.length-4
        csvdata[4+i*2,0] = "前日比"
      end
    else
      for i in 0..csvdata.length-4
        csvdata[4+i*2,0] = ((csvdata[3+i*2].to_f / csvdata[2].to_f - 1.0) * 100.0).round(2).to_s + "%"
      end
    end
  end

  # ファイルへ書き込み
  CSV.open(PerformanceFilename(), "w") do |csv|
    for csvdata in csvdatas
      csv << csvdata
    end
  end
end

def MakePricePercentCsv()
  csvdatas = CSV.read(PricelogFilename(), "r:utf-8")
  for csvdata in csvdatas
    #現在時刻の前日比を保持
    if csvdata[0] != "コード"
      zenjitsuhi_now = ((csvdata[3].to_f / csvdata[2].to_f - 1.0) * 100.0).round(2).to_s + "%"
    end
    #20分経過後は前日終値を除去
    if csvdata.length > 7
      csvdata.slice!(2)
    end
    #現時刻比の%表示を計算。タグはそのまま
    if csvdata[0] != "コード"
      for i in 3..csvdata.length-1
        csvdata[i] = ((csvdata[i].to_f / csvdata[2].to_f - 1.0) * 100.0).round(2).to_s
      end
      csvdata[2]=zenjitsuhi_now
    end
  end

  # ファイルへ書き込み
  CSV.open(PricePercentFilename(), "w") do |csv|
    for csvdata in csvdatas
      csv << csvdata
    end
  end
end



MakePricelogCsv()
MakePerformanceCsv()
MakePricePercentCsv()
