require 'nokogiri'
require 'httparty'
require 'byebug'
require 'csv'

@total = 0

@values = [
  #[16, 98, "Acupuncteur"],
  #[16, 57, "Algologue"],
  #[16, 2, "Allergologue"],
  #[16, 3, "Anatomopathologiste"],
  #[16, 4, "Anesthésiste-réanimateur"],
  #[16, 5, "Angiologue"],
  #[16, 68, "Audioprothésiste"],
  [16, 8, "Cardiologue"],
  #[16, 9, "Cardiologue pédiatrique", 2],
  #[16, 89, "Centre d'imagerie médicale", 2],
  #[16, 69, "Chiropracteur"],
  #[16, 10, "Chirurgien cardiaque", 2],
  #[16, 11, "Chirurgien cardiaque pédiatrique", 3],
  #[16, 65, "Chirurgien dentiste", 2],
  #[16, 12, "Chirurgien esthétique et plastique", 4],
  [16, 80, "Chirurgien généraliste", 2],
  #[16, 81, "Chirurgien infantile", 2],
  #[16, 13, "Chirurgien maxillo-facial", 2],
  #[16, 90, "Chirurgien Pédiatrique", 2],
  #[16, 14, "Chirurgien thoracique", 2],
  #[16, 15, "Chirurgien vasculaire", 2],
  #[16, 16, "Chirurgien viscérale", 2],
  #[16, 17, "Chirurgien viscérale pédiatrique", 3],
  #[16, 93, "Clinique chirurgicale", 2],
  #[16, 96, "Clinique d’hémodialyse", 2],
  #[16, 94, "Clinique médicale", 2],
  #[16, 95, "Clinique médico-chirurgicale", 2],
  #[16, 97, "Clinique spécialisée", 2],
  #[16, 54, "Dermato-vénérologue", 2],
  #[16, 70, "Diététicien"],
  #[16, 19, "Endocrino-diabetologue"],
  #[16, 20, "Gastro-entéro-hepatologue"],
  #[16, 21, "Généticien"],
  #[16, 22, "Gérontologue-gériatre"],
  #[16, 58, "Gynéco-obstetricien"],  
  #[16, 23, "Hématologue"], 
  #[16, 56, "Hépatologue"], 
  #[16, 83, "Infectiologue"],  
  #[16, 72, "Kinésithérapeute"],  
  #[16, 92, "Maladies et Chirurgie CardioVasculaire", 4],  
  #[16, 7, "Médecin Biologiste Laboratoire", 3],  
  #[16, 24, "Médecin du sport", 3],
  #[16, 25, "Médecin du travail", 3],  
  [16, 1, "Médecin géneraliste", 2],  
  #[16, 26, "Médecin interniste", 2], 
  #[16, 27, "Médecin légiste", 2],  
  #[16, 28, "Médecin nucléaire", 2],
  #[16, 29, "Médecin physique et de réadaptation", 5],
  #[16, 91, "Médecine esthétique"],
  #[16, 33, "Néphrologue"],
  #[16, 34, "Néphrologue pédiatrique", 2],
  #[16, 30, "Neuro-chirurgien"],
  #[16, 100, "Neuro-physiologiste"],
  #[16, 101, "Neuro-psychiatre"],
  #[16, 31, "Neurologue"], 
  #[16, 73, "Nutritionniste"],
  #[16, 35, "Onco-cancerologue"],
  #[16, 36, "Oncologue médical", 2],
  #[16, 53, "Ophtalmologue"],
  #[16, 99, "Optométriste"],
  #[16, 85, "ORL"],
  #[16, 74, "Orthophoniste"],
  #[16, 75, "Orthoptiste"],
  #[16, 67, "Ostéopathe"],
  [16, 52, "Pédiatre"]
  #[16, 51, "Phlébologue"],
  #[16, 38, "Pneumo-phtysio-allergologue"],
  #[16, 76, "Podologue"],
  #[16, 55, "Proctologue"],
  #[16, 39, "Psychiatre"],
  #[16, 77, "Psychologue"],
  #[16, 40, "Radiologue"], 
  #[16, 41, "Radiothérapeute"],
  #[16, 43, "Réanimateur médical", 2],
  #[16, 44, "Réanimateur pédiatrique", 2],
  #[16, 87, "Rééducation fonctionnelle", 2],
  #[16, 42, "Rhumatologue"],
  #[16, 45, "Sexologue"],
  #[16, 46, "Stomatologue"],
  #[16, 48, "Traumato-orthopédiste"],
  #[16, 47, "Traumato-orthopédiste pédiatrique", 2],
  #[16, 49, "Urologue"],
  #[16, 50, "Urologue pédiatrique"]
]

@total = []

def scrapper(id_1:, id_2:, type:, number:)
  url = "https://dzdoc.com/recherche.php?specialite=#{id_2}&region=#{id_1}"
  unparsed_page = HTTParty.get(url)
  parsed_page = Nokogiri::HTML(unparsed_page)
  job_listings = parsed_page.xpath('/html/body/div[3]/div[1]/div[2]/div').first.children.children.children.children.children.text
  per_page = parsed_page.xpath('/html/body/div[3]/div[1]/div[2]/div').count
  array_of_values = job_listings.split("\n").map{|v| v.strip }.reject { |c| c.strip.empty? }
  page = 1
  last_page = 3
  jobs = []
  while page <= last_page
    pagination_url = "https://dzdoc.com/recherche.php?specialite=#{id_2}&region=#{id_1}&p=#{page}"
    puts pagination_url
    puts "#{page}"
    puts " "
    pagination_unparsed_page = HTTParty.get(pagination_url)
    pagination_parsed_page = Nokogiri::HTML(pagination_unparsed_page)
    pagination_job_listings = pagination_parsed_page.xpath('/html/body/div[3]/div[1]/div[2]/div[1]/div/div')
    pagination_job_listings.each do |job_listing|
      data_hash = {
        #full_name: job_listing.children[1].children[1].children[1].children[1].children[1].children[3].text.split("\n").map{|c| c.strip }.reject{ |v| v.empty? }[0],
        full_name: job_listing.text.split("\n").map{|c| c.strip }.reject{|v| v.empty? }[0],
        address: job_listing.text.split("\n").map{|c| c.strip }.reject{|v| v.empty? }[2],
        city: "Alger",
        speciality: job_listing.text.split("\n").map{|c| c.strip }.reject{|v| v.empty? }[1]
      }
      jobs << [data_hash[:full_name], data_hash[:address], data_hash[:city], data_hash[:speciality]]
      puts "#{job_listing.text.split.first} ajouté"
      puts " "
    end
    page += 1
  end
  @total << jobs.count
  data_array = formatting(job_array: jobs, type: type, number: number)
end

def formatting(job_array:, type:, number:)
  number = 1 if number.nil?
  job_array.map do |job|
    hash = {
      full_name: job.first.nil? ? "Nom non-trouvé" : job.first,
      address: job[1],
      city: job[2],
      speciality: job.last.nil? ? "Spécialité non trouvée" : job.last.split.pop(number).join(' ').strip
    }
  end
end

def export_csv(data_array:, type:)
  counter = 0
  CSV.open("csv/#{type}_#{Time.now.strftime("%Y-%d-%m")}_#{Time.now.strftime("%H:%M:%S")}.csv", "w") do |csv|
    csv << ["full_name", "address", "city", "speciality"]
    data_array.flatten.map do |hash_info|
      csv << hash_info.values
      counter += 1
    end
    p "#{counter} datas importés de type : #{type} datant du #{Time.now.strftime("%Y-%d-%m")} à #{Time.now.strftime("%H:%M:%S")}"
  end
end


def perform
  array = []
  @values.each do |value|
    array << scrapper(id_1: value[0], id_2: value[1], type: value[2], number: value[3])
  end
  export_csv(data_array: array, type: "DZDOC")
  p "Fin du Scrapping des professionels de #{@values.count} spécialitées différentes"
  p "#{@total.sum} professionnels différents importé"
end

perform



