class MovieService
  def self.fetch_popular_movies
    key = ENV['movie_api_key']
    response1 = Faraday.get("https://api.themoviedb.org/3/movie/popular?api_key=#{key}&language=en-US&page=1")
    response2 = Faraday.get("https://api.themoviedb.org/3/movie/popular?api_key=#{key}&language=en-US&page=2")
    json1 = JSON.parse(response1.body, symbolize_names: true)
    json2 = JSON.parse(response2.body, symbolize_names: true)
    json1[:results] + json2[:results] # 40 movies returned
  end

  def self.get_search_results(search_params)
    return if search_params.nil?

    key = ENV['movie_api_key']
    search_params.gsub!(' ', '%20') if search_params.include?(' ')
    response1 = Faraday.get("https://api.themoviedb.org/3/search/movie?api_key=#{key}&language=en-US&query=#{search_params}&page=1&include_adult=false")
    response2 = Faraday.get("https://api.themoviedb.org/3/search/movie?api_key=#{key}&language=en-US&query=#{search_params}&page=2&include_adult=false")
    json1 = JSON.parse(response1.body, symbolize_names: true)
    json2 = JSON.parse(response2.body, symbolize_names: true)
    json1[:results] + json2[:results]
  end

  def self.get_movie_details(search_params)
    return if search_params.nil?

    key = ENV['movie_api_key']

    response = Faraday.get("https://api.themoviedb.org/3/movie/#{search_params}?api_key=#{key}&language=en-US")
    JSON.parse(response.body, symbolize_names: true)
  end

  def self.get_movie_cast_details(search_params)
    key = ENV['movie_api_key']
    response = Faraday.get("https://api.themoviedb.org/3/movie/#{search_params}/credits?api_key=#{key}&language=en-US")
    json = JSON.parse(response.body, symbolize_names: true)
    json[:cast][0..9] if json[:status_code] != 34
  end

  def self.get_movie_review_details(search_params)
    key = ENV['movie_api_key']
    response = Faraday.get("https://api.themoviedb.org/3/movie/#{search_params}/reviews?api_key=#{key}&language=en-US")
    json = JSON.parse(response.body, symbolize_names: true)
    json[:results] if json[:status_code] != 34
  end

  def self.get_buy_providers(search_params)
    key = ENV['movie_api_key']
    response = Faraday.get("https://api.themoviedb.org/3/movie/#{search_params}/watch/providers?api_key=#{key}")
    json = JSON.parse(response.body, symbolize_names: true)
    json[:results][:US][:buy]
    if json[:results][:US][:buy].nil?
      []
    else
      json[:results][:US][:buy]
    end
  end

  def self.get_rent_providers(search_params)
    key = ENV['movie_api_key']
    response = Faraday.get("https://api.themoviedb.org/3/movie/#{search_params}/watch/providers?api_key=#{key}")
    json = JSON.parse(response.body, symbolize_names: true)
    json[:results][:US][:rent]
    if json[:results][:US][:rent].nil?
      []
    else
      json[:results][:US][:rent]
    end
  end

  def self.get_streaming_providers(search_params)
    key = ENV['movie_api_key']
    response = Faraday.get("https://api.themoviedb.org/3/movie/#{search_params}/watch/providers?api_key=#{key}")
    json = JSON.parse(response.body, symbolize_names: true)
    if json[:results][:US][:flatrate].nil?
      []
    else
      json[:results][:US][:flatrate]
    end
  end

  def self.get_similar_movies(search_params)
    key = ENV['movie_api_key']
    response = Faraday.get("https://api.themoviedb.org/3/movie/#{search_params}/similar?api_key=#{key}&language=en-US&page=1")
    json = JSON.parse(response.body, symbolize_names: true)
    json[:results][0..4]
  end
end
