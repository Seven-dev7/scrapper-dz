require 'nokogiri'
require 'httparty'
require 'byebug'
require 'csv'

@total = 0

@values = [
  [16, 98, "Acupuncteur"],
  [16, 57, "Algologue"],
  [16, 2, "Allergologue"],
  [16, 3, "Anatomopathologiste"],
  [16, 4, "Anesthésiste-réanimateur"],
  [16, 5, "Angiologue"],
  [16, 68, "Audioprothésiste"],
  [16, 8, "Cardiologue"],
  [16, 9, "Cardiologue pédiatrique", 2],
  [16, 89, "Centre d'imagerie médicale", 2],
  [16, 69 "Chiropracteur"],
  [16, 10, "Chirurgien cardiaque", 2],
  [16, 11, "Chirurgien cardiaque pédiatrique", 3],
  [16, 65, "Chirurgien dentiste", 2],
  [16, 12, "Chirurgien esthétique et plastique", 4],
  [16, 80, "Chirurgien généraliste", 2],
  [16, 81, "Chirurgien infantile", 2],
  [16, 13, "Chirurgien maxillo-facial", 2],
  [16, 90, "Chirurgien Pédiatrique", 2],
  [16, 14, "Chirurgien thoracique", 2],
  [16, 15, "Chirurgien vasculaire", 2],
  [16, 16, "Chirurgien viscérale", 2],
  [16, 17, "Chirurgien viscérale pédiatrique", 3],
  [16, 93, "Clinique chirurgicale", 2],
  [16, 96, "Clinique d’hémodialyse", 2],
  [16, 94, "Clinique médicale", 2],
  [16, 95, "Clinique médico-chirurgicale", 2],
  [16, 97, "Clinique spécialisée", 2],
  [16, 54, "Dermato-vénérologue", 2],
  [16, 70, "Diététicien"],
  [16, 19, "Endocrino-diabetologue"],
  [16, 20, "Gastro-entéro-hepatologue"],
  [16, 21, "Généticien"],
  [16, 22, "Gérontologue-gériatre"],
  [16, 58, "Gynéco-obstetricien"],  
  [16, 23, "Hématologue"], 
  [16, 56, "Hépatologue"], 
  [16, 83, "Infectiologue"],  
  [16, 72, "Kinésithérapeute"],  
  [16, 92, "Maladies et Chirurgie CardioVasculaire", 4],  
  [16, 7, "Médecin Biologiste Laboratoire", 3],  
  [16, 24, "Médecin du sport", 3],
  [16, 25, "Médecin du travail", 3],  
  [16, 1, "Médecin géneraliste", 2],  
  [16, 26, "Médecin interniste", 2], 
  [16, 27, "Médecin légiste", 2],  
  [16, 28, "Médecin nucléaire", 2],
  [16, 29 "Médecin physique et de réadaptation", 5],
  [16, 91, "Médecine esthétique"],
  [16, 33, "Néphrologue"],
  [16, 34, "Néphrologue pédiatrique", 2],
  [16, 30, "Neuro-chirurgien"],
  [16, 100, "Neuro-physiologiste"],
  [16, 101, "Neuro-psychiatre"],
  [16, 31, "Neurologue"], 
  [16, 73, "Nutritionniste"],
  [16, 35, "Onco-cancerologue"],
  [16, 36, "Oncologue médical", 2],
  [16, 53, "Ophtalmologue"],
  [16, 99, "Optométriste"],
  [16, 85, "ORL"],
  [16, 74, "Orthophoniste"],
  [16, 75, "Orthoptiste"],
  [16, 67, "Ostéopathe"],
  [16, 52, "Pédiatre"],
  [16, 51, "Phlébologue"],
  [16, 38, "Pneumo-phtysio-allergologue"],
  [16, 76, "Podologue"],
  [16, 55, "Proctologue"],
  [16, 39, "Psychiatre"],
  [16, 77, "Psychologue"],
  [16, 40, "Radiologue"], 
  [16, 41, "Radiothérapeute"],
  [16, 43, "Réanimateur médical", 2],
  [16, 44, "Réanimateur pédiatrique", 2],
  [16, 87, "Rééducation fonctionnelle", 2],
  [16, 42, "Rhumatologue"],
  [16, 45, "Sexologue"],
  [16, 46, "Stomatologue"],
  [16, 48, "Traumato-orthopédiste"],
  [16, 47, "Traumato-orthopédiste pédiatrique", 2],
  [16, 49, "Urologue"],
  [16, 50, "Urologue pédiatrique"]
]

def scrapper
  url = "https://dzdoc.com/"
  #url = "https://www.sahti-dz.com/recherche.aspx?p=#{id_1}&sp=#{id_2}&w=&c=&s=&disp=&sort=&page=1#ShowResults"
  unparsed_page = HTTParty.get(url)
  parsed_page = Nokogiri::HTML(unparsed_page)
  jobs = []
  job_listings = parsed_page.css('html body div.push div.container-fluid div.container div.row.mar-b-20 div.col-md-6.pad-b-35.box-shadow form#recherche div.form-group div.selectize-control.form-control.single div.selectize-dropdown.single.form-control div.selectize-dropdown-content').text
  #per_page = job_listings.count
  byebug
  #total = parsed_page.css('').text.split.map {|x| x[/\d+/]}.first.to_i
  #@total << total
  page = 1
  #last_page = (total.to_f / per_page.to_f).round
  #while page <= last_page
#
  #end
end

def perform
  scrapper
end

perform



