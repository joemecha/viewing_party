require 'rails_helper'

RSpec.describe 'Movie Service' do
  describe '#instance method' do
    describe 'get_movie_data' do
      it 'returns data on forty movies' do
        json_response_1 = json_response = File.read('spec/fixtures/popular_movies_page_1.json')
        stub_request(:get, "https://api.themoviedb.org/3/movie/popular?api_key=7de6854d5aec975cccb0997bfb31ca9d&language=en-US&page=1").
         with(
           headers: {
       	  'Accept'=>'*/*',
       	  'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
       	  'User-Agent'=>'Faraday v1.4.1'
           }).
         to_return(status: 200, body: json_response_1, headers: {})

        json_response_2 = json_response = File.read('spec/fixtures/popular_movies_page_2.json')
        stub_request(:get, "https://api.themoviedb.org/3/movie/popular?api_key=7de6854d5aec975cccb0997bfb31ca9d&language=en-US&page=2").
         with(
           headers: {
       	  'Accept'=>'*/*',
       	  'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
       	  'User-Agent'=>'Faraday v1.4.1'
           }).
         to_return(status: 200, body: json_response_2, headers: {})
      
        test = MovieService.new
        results = test.get_popular_movies
        expect(results.count).to eq(40)
      end

      it 'returns data on search results' do
        json_response = json_response = File.read('spec/fixtures/search_results.json')
        stub_request(:get, "https://api.themoviedb.org/3/search/movie?api_key=7de6854d5aec975cccb0997bfb31ca9d&include_adult=false&language=en-US&page=1&query=Mortal%20Kombat").
         with(
           headers: {
       	  'Accept'=>'*/*',
       	  'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
       	  'User-Agent'=>'Faraday v1.4.1'
           }).
         to_return(status: 200, body: json_response, headers: {})

        test = MovieService.new
        results = test.get_search_results('Mortal Kombat')

        expect(results.count).to eq(15)
      end

      it 'returns data on a specific movie' do
        json_response = json_response = File.read('spec/fixtures/movie_details.json')
        stub_request(:get, "https://api.themoviedb.org/3/movie/460465?api_key=7de6854d5aec975cccb0997bfb31ca9d&language=en-US").
         with(
           headers: {
       	  'Accept'=>'*/*',
       	  'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
       	  'User-Agent'=>'Faraday v1.4.1'
           }).
         to_return(status: 200, body: json_response, headers: {})

        test = MovieService.new
        results = test.get_movie_details('460465')

        expect(results[:title]).to eq('Mortal Kombat')
        expect(results[:vote_average]).to eq(7.7)
        expect(results[:runtime]).to eq(110)
        expect(results[:genres][0][:name]).to eq('Action')
        expect(results[:overview].split(' ').first).to eq('Washed-up')
      end

      it 'returns cast info for a specific movie' do
        json_response = json_response = File.read('spec/fixtures/cast_details.json')
        stub_request(:get, "https://api.themoviedb.org/3/movie/460465/credits?api_key=7de6854d5aec975cccb0997bfb31ca9d&language=en-US").
         with(
           headers: {
       	  'Accept'=>'*/*',
       	  'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
       	  'User-Agent'=>'Faraday v1.4.1'
           }).
         to_return(status: 200, body: json_response, headers: {})

        test = MovieService.new
        results = test.get_movie_cast_details('460465')

        expect(results[0][:name]).to eq('Lewis Tan')
        expect(results[0][:character]).to eq('Cole Young')
        expect(results[1][:name]).to eq('Jessica McNamee')
        expect(results[1][:character]).to eq('Sonya Blade')
      end

      it 'returns each reviewer author and info' do
        json_response = File.read('spec/fixtures/reviews.json')
        stub_request(:get, "https://api.themoviedb.org/3/movie/460465/reviews?api_key=7de6854d5aec975cccb0997bfb31ca9d&language=en-US").
         with(
           headers: {
       	  'Accept'=>'*/*',
       	  'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
       	  'User-Agent'=>'Faraday v1.4.1'
           }).
         to_return(status: 200, body: json_response, headers: {})

        test = MovieService.new
        results = test.get_movie_review_details('460465')

        expect(results[0][:author_details][:username]).to eq('TheDarkKnight31')
        expect(results[0][:author_details][:rating]).to eq(10.0)
        expect(results[2][:author_details][:username]).to eq('msbreviews')
        expect(results[2][:author_details][:rating]).to eq(6.0)
      end
    end
  end
end
