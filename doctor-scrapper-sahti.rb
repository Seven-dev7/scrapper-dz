require 'nokogiri'
require 'httparty'
require 'byebug'
require 'csv'

ARRAY = [
  [2, 12, 'Pharmacien'],
  [1, 35, 'Chirurgien dentiste'],
  [0, 39, "Cardiologue"],
  [0, 27, "Chirurgien général"],
  [0, 42, 'Medecine generale']
]
def scrapper(id_1: , id_2:, type:)
  url = "https://www.sahti-dz.com/recherche.aspx?p=#{id_1}&sp=#{id_2}&w=&c=&s=&disp=&sort=&page=1#ShowResults"
  unparsed_page = HTTParty.get(url)
  parsed_page = Nokogiri::HTML(unparsed_page)
  jobs = []
  job_listings = parsed_page.css('html body form#form1 div.wrap div.content.container div.row div div.body.no-margin div#MainContent_SearchResultsDiv div.col-lg-12.col-md-12.col-sm-12.col-xs-12 section.widget div.row div.col-lg-12.col-md-12.col-sm-12.col-xs-12')
  per_page = job_listings.count
  total = parsed_page.css('html body form#form1 div.wrap div.content.container div.row div div.body.no-margin div#MainContent_SearchResultsDiv div.col-lg-12.col-md-12.col-sm-12.col-xs-12 section.widget h4 strong small').text.split.map {|x| x[/\d+/]}.first.to_i
  page = 1
  last_page = (total.to_f / per_page.to_f).round
  while page <= last_page
    pagination_url = "https://www.sahti-dz.com/recherche.aspx?p=#{id_1}&sp=#{id_2}&w=&c=&s=&disp=&sort=&page=#{page}#ShowResults"
    puts pagination_url
    puts "#{page}"
    puts " "
    pagination_unparsed_page = HTTParty.get(pagination_url)
    pagination_parsed_page = Nokogiri::HTML(pagination_unparsed_page)
    pagination_job_listings = pagination_parsed_page.css('html body form#form1 div.wrap div.content.container div.row div div.body.no-margin div#MainContent_SearchResultsDiv div.col-lg-12.col-md-12.col-sm-12.col-xs-12 section.widget div.row div.col-lg-12.col-md-12.col-sm-12.col-xs-12')
    pagination_job_listings.each do |job_listing|
      data_hash = {
        full_name: job_listing.children[0].children[0].children[0].text ? job_listing.children[0].children[0].children[0].text : "Full name non récupérer",
        address_phone: job_listing.children[0].children[0].children[1].text ? job_listing.children[0].children[0].children[1].text : "Adresse et Numéro non récupérer",
        speciality: 'pharmacie'
      }
      jobs << [data_hash[:full_name], data_hash[:address_phone], data_hash[:speciality]]
      puts "#{job_listing.text.split.first} ajouté"
      puts " "
    end
    page += 1
  end
  data_array = formatting(job_array: jobs, type: type, number: 2)
  export_csv(data_array: data_array, type: type)
end

def formatting(job_array:, type:, number: 1)
  job_array.map do |job|
    hash = {
      full_name: job.first.split.reject{ |k| k == type }.join(' '),
      speciality: number == 2 ? job.first.split.pop(2).join(' ').strip : job.first.split.pop.strip,
      address: job[1],
      city: job[1].split(" ").last.tr("0-9", ""),
      phone_number: job[1].split(" ").last.delete('^0-9')
    }
  end
end

def export_csv(data_array:, type:)
  CSV.open("#{type}_#{Time.now.strftime("%Y-%d-%m")}_#{Time.now.strftime("%H:%M:%S")}.csv", "w") do |csv|
    counter = 0
    csv << ["full_name", "speciality", "address", "city", "phone_number"]
    data_array.map do |hash_info|
      csv << hash_info.values
      counter += 1
    end
    p "#{counter} datas importés de type : #{type} datant du #{Time.now.strftime("%Y-%d-%m")} à #{Time.now.strftime("%H:%M:%S")}"
  end
end

def perform
  ARRAY.each do |ids|
    scrapper(id_1: ids[0], id_2: ids[1], type: ids[2])
  end
  p "Fin du Scrapping"
end

perform