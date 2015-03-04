require 'nokogiri'
require 'open-uri'
require 'uri'

class IndexController < ApplicationController
	skip_before_action :verify_authenticity_token

	def index
	end

	def show
		pageUrl = params[:url]
		uri = URI(pageUrl)
		case uri.host
		when "kienthuc.net.vn"
			@content = kienthuc(pageUrl)
		when "kenh14.vn"
			@content = kenh14(pageUrl)
		when "vnexpress.net"
			@content = vnexpress(pageUrl)
		else
			@content = unknow(pageUrl)
		end
		@url = pageUrl
	end


	private
		def unknow(pageUrl)
			doc = Nokogiri::HTML(open(pageUrl))
			body = doc.css('body')
			body.xpath('//@style').remove
			body.xpath('//@class').remove
			body.xpath('//@id').remove
			body.inner_html
		end

		def vnexpress(pageUrl)
			doc = Nokogiri::HTML(open(pageUrl))
			body = doc.css('#left_calculator > div.fck_detail.width_common')
			body.xpath('//@style').remove
			body.xpath('//@class').remove
			body.xpath('//@id').remove
			body.inner_html
		end

		def kienthuc(pageUrl)
			doc = Nokogiri::HTML(open(pageUrl))
			body = doc.css('div#abody')
			body.xpath('//@style').remove
			body.xpath('//@class').remove
			body.xpath('//@id').remove
			body.css('div').each do |div|
				if div.content == ''
					div.remove
				else
					img = div.css('img')
					if img.count == 0
						div.name = 'p'
					end
				end
			end
			body.inner_html
		end

		def kenh14(pageUrl)
			doc = Nokogiri::HTML(open(pageUrl))
			body = doc.css('#admWrapsite > div.contentwrapper > div > div > div.maincontent.clearfix > div.postwrapper.clearfix > div:nth-child(1) > div.content > div')
			body.xpath('//@style').remove
			body.xpath('//@class').remove
			body.xpath('//@id').remove
			body.inner_html
		end
end