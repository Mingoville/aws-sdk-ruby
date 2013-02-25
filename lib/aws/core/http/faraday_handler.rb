module AWS
  module Core
    module Http
      class FaradayHandler

        def initialize

        end

        def handle request, response, &read_block


          url_proto = request.use_ssl? ? "https:/" : "http:/"
          url_host = request.host
          url_port = request.port

          conn = Faraday.new("#{url_proto}/#{url_host}:#{url_port}")

          begin

            response = conn.run_request(request.http_method.downcase.to_sym,
                             request.uri,
                             request.body_stream.read, request.headers)

            #connection = pool.connection_for(request.host, options)
            #connection.read_timeout = request.read_timeout
            #
            #connection.request(build_net_http_request(request)) do |http_resp|
            #  response.status = http_resp.code.to_i
            #  response.headers = http_resp.to_hash
            #  if block_given? and response.status < 300
            #    http_resp.read_body(&read_block)
            #  else
            #    response.body = http_resp.read_body
            #  end
            #end

              # The first rescue clause is required because Timeout::Error is
              # a SignalException (in Ruby 1.8, not 1.9).  Generally, SingalExceptions
              # should not be retried, except for timeout errors.
          rescue Timeout::Error => error
            response.network_error = error
          rescue *PASS_THROUGH_ERRORS => error
            raise error
          rescue Exception => error
            response.network_error = error
          end

          nil

        end

        def build_net_http_request request

        end

      end
    end
  end
end

