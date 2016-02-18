[
	"open-uri",
	"nokogiri"
].each{|g|
	require g
}

url=	"http://www.missionarychapel.com/modules.php?name=roster_of_churches&page="

File.open("MissionaryChapelRoster.txt", "w"){|file|
	file.puts(
		[
			"Founded",
			"Founder",
			"Location",
			"Church name"
		].join("\t")
	)

	(1..38).each{|pagenum|
		page=	Nokogiri::HTML(open(url+pagenum.to_s))

		tables= page.css("tr table table table table table")
		tables.each_with_index{|table,i|
			if i%3==0
				infoElems=	table.css('font[style="font-size: 10px;"]')
				infoArray=	infoElems.map{|elem| elem.text.gsub(/\bFounded\b|\bFounder\b|\bLocation\b|\:/,"").strip}
				

				if infoArray.length>0
					infoArray.push(table.css('b').text.strip)
					file.puts(infoArray.join("\t"))
					p infoArray
				end
				p '==='
			end
		}
	}
}

