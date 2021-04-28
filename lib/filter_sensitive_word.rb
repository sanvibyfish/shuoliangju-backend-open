require "set"
require "pry"
require 'active_support/core_ext'

Word = Struct.new(:is_end, :value)

class FilterSensitiveWord
  attr_accessor :words
  MIN_MATCH_TYPE = 1
  MAX_MATCH_TYPE = 2

  def initialize()
    @hash = Hash.new
  end

  def load(file_path)
    @words = Set[]
    f = File.open(file_path, "r")
    f.each_line do |line|
      @words.add(line)
    end
    f.close
    to_hash(@words)
  end

  def to_hash(words)
   words.map do |word|
      word_hash = @hash
      word.strip.chars.to_a.map.with_index do |c,index|
        if word_hash[c].blank?
          if word.strip.length - 1 == index
            word_hash[c] = Word.new(true,Hash.new)
          else
            word_hash[c] = Word.new(false,Hash.new)
            word_hash = word_hash[c].value
          end
        else
          word_hash = word_hash[c].value
        end
      end
    end
    @hash
  end

  def check_sensitive_word(txt, index, match_tpye) 
    match_flag = 0
    word_hash = @hash
    flag = false
    txt.each do |w|
      if word_hash[w].blank?
        break
      else
        match_flag = match_flag + 1
        if word_hash[w].is_end
          flag = true
          if match_tpye == MIN_MATCH_TYPE
            break
          end
        else 
          word_hash = word_hash[w].value
        end
      end
    end
    unless flag
      match_flag = 0
    end
    match_flag
  end


  def check(text,match_tpye)
    words = []
    skip_len = 0
    text = text.to_s.strip.gsub(/[`~!@#$^&*()=|{}':;',\\\[\]\.<>\/?~！@#￥……&*（）——|{}【】'；：""'。，、？]/,'')
    if text.present?
      text.chars.each_with_index do |c, i| 
        if skip_len > i
          next
        end
        len = check_sensitive_word(text.chars.drop(i), i, match_tpye)
        if len > 0
          words.push text[i, len]
          skip_len = i + len - 1
        end 
      end
    end

    words
  end

end


# $filter_sensitive_word = FilterSensitiveWord.new()
# $filter_sensitive_word.load("./words/广告.txt")
# $filter_sensitive_word.load("./words/政治类.txt")
# $filter_sensitive_word.load("./words/涉枪涉爆违法信息关键词.txt")
# $filter_sensitive_word.load("./words/色情类.txt")
# puts $filter_sensitive_word.check("远程办公是否会成为未来办公趋势？Facebook CEO 马克· 扎克伯格周四表示，他预计，未来5到10年，有50%的员工可能都会远程工作。扎克伯格宣布，Facebook将更多招聘远程工作员工，并循序渐进地为现有员工开设永久性远程工作职位。此前Twitter刚宣布9月之前不会开放大部分办公室，员工可以选择是否回去上班。但鲜有听国内的大厂说到9月都不会回办公室。我觉得国内外差异化比较大的主要是对疫情的应对和现状。大家还记得春节后回去上班都是一拖再拖，并无明确那么长的时间，主要是大厂相信我国对疫情的治理方案和力度，从信息透明到大家都能看到3月其实已经开始恢复了，5月基本恢复产能。国外的现状大家也能了解，能了解的人都清楚，硅谷的老大都和川普不和。具体原因大家可以看到一些报道，所以普遍对疫情相对悲观。所以大家才能看到大家都到9月的报道。另外大家能看到，疫情期间，各家协作软件大火。想到国内一些做视频会议的，招聘里说项目经理都去写代码了，可想而之这个赛道跑的多辛苦。其实远程办公在国外已经是一种常态，想我多年前都开始使用trello、zoom等软件开始远程办公，经过数年的迭代，比起目前国内的还是稍微优质一点。另外跟国内公司不一样，国外的市场基本上是全球化的，天生就需要远程办公，你不能叫别人天天飞十几个小时开会吧。回到一开始的题目，远程办公会是未来吗？我的看法暂时不会，一是疫情影响周期太短了，大家刚开始入门就回公司上班了，另外国内软件刚起步，问题还很多，就比如最近从zoom（zoom不对国内个人用户免费了）换回来国内产品，存在各种问题，比如一视频电脑风扇CPU就叫个不停。所以远程是否能大火，那要还等下一次机会，这次大厂们已经做好了准备。",1)