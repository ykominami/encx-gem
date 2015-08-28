require "encx/version"

module Encx
  class Encx
    def Encx.init(enc)
      @@encx = Encx.new(enc)
    end
    
    def Encx.encx
      @@encx
    end

    def initialize(enc)
      @encoding = enc
      @encodings = [Encoding::Shift_JIS , Encoding::UTF_8 , Encoding::EUC_JP]
      @ext_encodings = @encodings.select{ |x| x != @encoding }
      @encoding_ary = [@encoding] + @ext_encodings

      @re = nil
      @last_match = nil
      @last_match0 = nil
      
      @cur_target = nil
      @targets = []
      @target_for_display = []
      
      @error_target_item_hs = {}

    end

    def make_regexp( data , option = nil )
      hs = {}
      @encoding_ary.each do |enc|
        if data.class == Array
          hs[enc] = []
          data.each do |d|
            #          d_puts "make_regexp d=#{d}"
            hs[enc] << Regexp.new( convert(d , enc) , option )
          end
        else
          #        d_puts "make_regexp data=#{data}"
          hs[enc] = Regexp.new( convert(data , enc) , option )
        end
      end
      hs
    end

    def compare(l , hs)
      ret2 = @encoding_ary.find{ |x|
        begin
          p hs[x]
          ret = hs[x].match(l)
          if ret
            ret = true
            @re = hs[x]
            @last_match = Regexp.last_match[1]
            @last_match0 = Regexp.last_match[0]
          else
            ret = false
            @last_match = nil
            @last_match0 = nil
          end
        rescue => ex
          exp = true
        end

        ret
      }

      ret2 != nil
    end
    
    def convert( d , enc = nil )
      if enc
        d.encode( enc , {:undef=>:replace, :invalid=>:replace, :replace => ""})
      else
        d.encode( @encoding , {:undef=>:replace, :invalid=>:replace, :replace => ""})
      end
    end

    def conv_env_sub( d , enc = nil )
      val = nil
      if enc != @encoding
        begin
          val = d.encode( enc )
          #            val = d.encode( enc , {:undef=>:replace, :invalid=>:replace, :replace => ""})
        rescue => exp
          ret = false
        end
      else
        val=d
      end
      [ret , val]
    end
    
    def conv_env( d , enc = nil )
      val = nil
      if enc
        ret , val = conv_env_sub( d , enc )
      else
        ret2 = @encoding_ary.find{ |enc|
          ret , val = conv_env_sub( d , enc )
          
          ret
        }
      end
      val
    end
    
    def register_error( target  , item )
      @error_target_item_hs[target] ||= []
      @error_target_item_hs[target] << item
    end
    
    def print_error_register_item
      @error_target_item_hs.each do |k,v|
        puts "##{k}"
        v.each do |item| 
          puts "==#{item}"
        end
      end
    end
  end
end
