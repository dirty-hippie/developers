module PlacesHelper

  def parse_filters_from options
    if options[:what].nil? or options[:what].size < 1
      return options
    end

    filters = []
    words = options[:what].split(' ')
    words.reject!{|word| Tire.russian_stopwords.include?(word) or word.length < 3 }
    words.each do |word|
      res = Filter.find(word)
      unless res.empty?
        filters += res
        options[:what].gsub!(word,'')
      end
    end

    options[:what] = options[:what].split(' ')
    options[:what] = options[:what].reject{|word| Tire.russian_stopwords.include?(word) or word.length < 3 }
    options[:what] = options[:what].join(' ')
    filters.each do |f|
      options[ f[:type].to_sym ] = { f[:value].to_s => f[:value].to_s }
    end
    options
  end
end