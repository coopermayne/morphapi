datas = [
  {
    section: "Architecture",
    project_id: 9314,
    file_location: "db/morph\ data/3-architecture/1-hanking-center-tower/hct-plaza.jpg"
  },
  {
    section: "Architecture",
    project_id: 9314,
    file_location: "db/morph\ data/3-architecture/1-hanking-center-tower/hct-retail-lux.jpg"
  },
  {
    section: "Architecture",
    project_id: 8909,
    file_location: "db/morph\ data/3-architecture/2-bloomberg-center/cny-center-court-final-blur.jpg"
  },
  {
    section: "Architecture",
    project_id: 8909,
    file_location: "db/morph\ data/3-architecture/2-bloomberg-center/cny-waterfront-final-blur.jpg"
  },
  {
    section: "Architecture",
    project_id: 9021,
    file_location: "db/morph\ data/3-architecture/3-bill/cis-rh2290-0030.jpg"
  },
  {
    section: "Architecture",
    project_id: 9021,
    file_location: "db/morph\ data/3-architecture/3-bill/cis-rh2290-0068.jpg"
  },
  {
    section: "Architecture",
    project_id: 6443,
    file_location: "db/morph\ data/3-architecture/4-emerson-college-los-angeles/ela-img-2851-jp.jpg"
  },
  {
    section: "Architecture",
    project_id: 6443,
    file_location: "db/morph\ data/3-architecture/4-emerson-college-los-angeles/ela-img-5624-jp-crop.jpg"
  }
]
datas.each do |data|
  sl = Slide.new()
  sl.section = Section.find_by_title(data[:section])
  sl.project = Project.find(data[:project_id])

  u = Upload.new
  u.name = File.open(Rails.root.join(data[ :file_location ]))
  sl.image = u

  puts sl.save
end




#section content
#s = Section.find_by_title("Morphosis")
#s.content = "
#Title: Morphosis

#----

#Text: Culver City:
#3440 Wesley Street
#Culver City, California 90232
#+1 (424) 258 6200

#New York City:
#153 West 27th Street, Suite 1200
#New York, New York 10001
#+1 (212) 675 1100

#General Inquiries
#+1 (424) 258 6200 telephone
#(email: studio@morphosis.net text: studio@morphosis.net)

#Business Development
#Arne Emerson
#(email: a.emerson@morphosis.net text: a.emerson@morphosis.net)

#Press Inquiries
#Jane Suthi
#(email: press@morphosis.net text: press@morphosis.net)

#Archives & Exhibitions
#Nicole Meyer
#(email: n.meyer@morphosis.net text: n.meyer@morphosis.net)

#Accounting
#Jenn Ramsey
#(email: j.ramsey@morphosis.net text: j.ramsey@morphosis.net)

#Employment Inquiries
#(email: studio@morphosis.net text: studio@morphosis.net)

#Internship Inquiries
#Chris Eskew
#(email: c.eskew@morphosis.net text: c.eskew@morphosis.net)

#----

#Links: - 
  #title: Awards
  #link: >
    #http://morphopedia.com/information/recognition/1/
#- 
  #title: People
  #link: >
    #http://morphopedia.com/people/alphabetical/1/

#----

#About: Founded in 1972, Morphosis is an interdisciplinary practice involved in rigorous design and research that yields innovative, iconic buildings and urban environments. With founder Thom Mayne serving as design director, the firm today consists of a group of more than 60 professionals, who remain committed to the practice of architecture as a collaborative enterprise. With projects worldwide, the firm’s work ranges in scale from residential, institutional, and civic buildings to large urban planning projects. Named after the Greek term, *morphosis*, meaning to form or be in formation, Morphosis is a dynamic and evolving practice that responds to the shifting and advancing social, cultural, political and technological conditions of modern life. Over the past 30 years, Morphosis has received 25 Progressive Architecture awards, over 100 American Institute of Architects (AIA) awards, and numerous other honors.

#----

#Employment: Full Time Employment:
#If you are interested in pursuing employment opportunities at Morphosis, you are welcome to submit your portfolio and resume for review. For current opportunities please see our news page. We prefer digital applications, and will also consider printed applications, however your portfolio will not be returned. Please limit any email attachments to 5 MB. Due to the large number of inquiries we receive, we are unable to respond to or interview each candidate. We will contact you if there is an interest in your work.

#Internships At Morphosis:
#Morphosis offers six-month internships to advanced undergraduate and graduate students. You are welcome to submit your digital internship application for review. Please limit any email attachments to 5 MB. Please include your resume, samples of your work, any letters of recommendation, and the dates you are available with your cover letter explaining you are applying for an internship. Due to the large number of inquiries we receive, we are unable to respond to each candidate. We do not conduct interviews for internship positions — selection is based solely on your portfolio and other application materials."

#s.save
