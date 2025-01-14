module Seeders
    class InitStockData < ApplicationService

        def invoke
            @logger.info 'Starting stock seed invocation'
            Stock.destroy_all
            @logger.info 'Purged all data in Stock model'

            client = IEX::Api::Client.new(
                publishable_token: Rails.application.credentials.config[:stocks_api_key],
                secret_token: Rails.application.credentials.config[:secret_api_key],
                endpoint: 'https://sandbox.iexapis.com/v1'
            )


            @logger.info 'Fetching tickers from text file'
            raw_list = File.open('app/assets/stock_list/blue_chips.txt')
            list = raw_list.readlines.map(&:chomp)

            list.each do |data|
                begin
                profile = Finnhub::Client.profile(data)
                Stock.create({
                    ticker: data, 
                    name: client.company(data).company_name,
                    current_price: client.price(data), 
                    logo_url: profile["logo"]
                })
                rescue  => e
                    @logger.info "#{e.message}"
                else
                    @logger.info "#{data} market info added"
                end
            end
            @logger.info 'Stock data initialized'
        end
    end
end