require 'nokogiri'
require 'httparty'
require 'byebug'
require 'csv'

@values = [ # id_1: select 1, id_2: select 2, type, number: nombre de mot dans le type
  [2, 12, "Pharmacien"],
  [1, 35, "Chirurgien dentiste", 2],
  [1, 50, "Endodontiste"],
  [1, 51, "Implantologiste"],
  [1, 52, "Occlusodontiste"],
  [1, 53, "Orthodontiste"],
  [1, 54, "Parodontologiste"],
  [1, 55, "Pédodontiste"],
  [0, 39, "Cardiologue"],
  [0, 27, "Chirurgien général", 2],
  [0, 42, "Médecin généraliste", 2]
  #[0, 9, "Allergologue"],
  #[0, 5, "Anatomie et cytologie pathologique", 4],
  #[0, 59, "Biologie Clinique", 2],
  #[0, 39, "Cardiologue"],
  #[0, 62, "Chirurgie pédiatrique", 2],
  #[0, 29, "Chirurgien Cardiaque", 2],
  #[0, 27, "Chirurgien général", 2],
  #[0, 32, "Chirurgien Maxillo-facial", 2],
  #[0, 4, "Chirurgien Plastique", 2],
  #[0, 18, "Chirurgien Thoracique", 2],
  #[0, 31, "Chirurgien Urologue", 2],
  #[0, 14, "Chirurgien vasculaire", 2],
  #[0, 41, "Dermatologue"],
  #[0, 40, "Diabétologue"],
  #[0, 15, "Endocrinologue"],
  #[0, 49, "Epidemiologiste"],
  #[0, 26, "Gastrologue"],
  #[0, 45, "Gynécologue"],
  #[0, 37, "Hématologue"],
  #[0, 22, "Histologiste"],
  #[0, 46, "Médecin biologiste", 2],
  #[0, 44, "Médecin du sport", 3],
  #[0, 30, "Médecin du travail", 3],
  #[0, 60, "Médecin esthétique", 2],
  #[0, 42, "Médecin généraliste", 2],
  #[0, 23, "Médecin Infectiologue", 2],
  #[0, 13, "Médecin interniste", 2],
  #[0, 48, "Médecin légiste", 2],
  #[0, 10, "Médecin Radiologue", 2],
  #[0, 24, "Médecin réanimateur", 2],
  #[0, 43, "Médecin rééducateur", 2],
  #[0, 8, "Microbiologiste"],
  #[0, 33, "Nephrologue"],
  #[0, 3, "Neurochirurgien"],
  #[0, 9, "Neurologue"],
  #[0, 16, "Oncologue"],
  #[0, 21, "Ophtalmologue"],
  #[0, 25, "ORL"],
  #[0, 28, "Orthopédiste"],
  #[0, 6, "Pediatre"],
  #[0, 7, "Pneumo-Phtisiologue"],
  #[0, 17, "Psychiatre"],
  #[0, 47, "Radiologue"],
  #[0, 20, "Radiothérapeute"],
  #[0, 36, "Radiothérapeute oncologue", 2],
  #[0, 34, "Rhumatologue"],
  #[0, 38, "Sénologue"],
  #[0, 11, "Toxicologue"],
  #[0, 2, "Urologue"]
]
@total = [] 

def scrapper(id_1: , id_2:, type:, number:, total: @total)
  url = "https://www.sahti-dz.com/recherche.aspx?p=#{id_1}&sp=#{id_2}&w=&c=&s=&disp=&sort=&page=1#ShowResults"
  unparsed_page = HTTParty.get(url)
  parsed_page = Nokogiri::HTML(unparsed_page)
  jobs = []
  job_listings = parsed_page.css('html body form#form1 div.wrap div.content.container div.row div div.body.no-margin div#MainContent_SearchResultsDiv div.col-lg-12.col-md-12.col-sm-12.col-xs-12 section.widget div.row div.col-lg-12.col-md-12.col-sm-12.col-xs-12')
  per_page = job_listings.count
  total = parsed_page.css('html body form#form1 div.wrap div.content.container div.row div div.body.no-margin div#MainContent_SearchResultsDiv div.col-lg-12.col-md-12.col-sm-12.col-xs-12 section.widget h4 strong small').text.split.map {|x| x[/\d+/]}.first.to_i
  @total << total
  page = 1
  last_page = (total.to_f / per_page.to_f).round
  while page <= 3
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
  data_array = formatting(job_array: jobs, type: type, number: number)
end

def formatting(job_array:, type:, number:)
  number = 1 if number.nil?
  job_array.map do |job|
    hash = {
      full_name: number == 2 ? job.first.split[0..-3].join(' ') : job.first.split[0..-2].join('').strip,
      address: job[1],
      city: job[1].split(" ").last.tr("0-9", ""),
      speciality: job.first.nil? ? "Spécialité non trouvée" : job.first.split.pop(number).join(' ').strip,
      phone_number: job[1].split(" ").last.delete('^0-9')
    }
  end
end

def export_csv(data_array:, type:)
  counter = 0
  CSV.open("csv/#{type}_#{Time.now.strftime("%Y-%d-%m")}_#{Time.now.strftime("%H:%M:%S")}.csv", "w") do |csv|
    csv << ["full_name", "address", "city", "speciality", "phone_number"]
    data_array.flatten.map do |hash_info|
      csv << hash_info.values
      counter += 1
    end
    p "#{counter} datas importés de type : #{type} datant du #{Time.now.strftime("%Y-%d-%m")} à #{Time.now.strftime("%H:%M:%S")}"
  end
end

def perform
  begin_time = Time.now.strftime("%H:%M:%S")
  array = []
  @values.each do |value|
    array << scrapper(id_1: value[0], id_2: value[1], type: value[2], number: value[3], total: @total)
  end
  export_csv(data_array: array, type: "sahti")
  end_time = Time.now.strftime("%H:%M:%S")
  p "Fin du Scrapping des professionels de #{@values.count} spécialitées différentes"
  p "#{@total.sum} professionnels sur alger récupéré"
  p " heure de début #{begin_time}"
  p "heure de fin #{end_time}"
end

perform



