class Array
  def where(h)
    out = self
    h.each do |key, value|
      #puts value
      #puts value.class
      tmp = []
      if value.class != Regexp

        out.each do |hash|
          if(hash[key] != value)
            tmp.push(hash)
          end
        end

        tmp.each do |badhash|
          out.delete(badhash)
        end


      end


      temp = []
      if value.class ==  Regexp
        self.each do |hasher|

          arr = hasher[key]

          if value =~ arr
            # do nothing, I couldn't figure out how to do != with =~
          else
            temp.push(hasher)
          end

        end
      end


      temp.each do |item|
        if out.include? item
          out.delete item
        end
      end

    end
    return out
  end
end