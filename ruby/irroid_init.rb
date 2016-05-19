#!/usr/local/bin/ruby
# coding: utf-8

require 'jpstock'
require './config'

#取得する会社の証券コード
codes = ["2379","2503","2931","3326","3401","3660","3668","3680","3853","4348","4751","5201","5715","6090","6506","6753","7438","7571","8154","8697","9432","9619"]

filename = "performance.csv"

# 会社名を処理
def CompanyName(comname)
    comname = comname.delete("(株)")
    comname = comname.gsub(/ホールディングス/,"HD")
    comname = comname.gsub(/グループ/,"G")
    comname = comname.gsub(/ヒューマン・メタボローム・テクノロジーズ/,"HMT")
    comname = comname.gsub(/サイバーエージェント/,"サイバーA")
end

# ファイルへ書き込み
CSV.open(CsvPath(filename), "w") do |csv|
  csv << ["コード", "銘柄", "前日終値"]
  
  #前日終値を取得
  for code in codes
    data = JpStock.quote(:code=>code)
    comname = CompanyName(data.company_name)
    csv << [code, comname, data.prev_close]
    sleep(1)
  end
end