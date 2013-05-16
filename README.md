This is the Hawaii Data Pipeline tool.  It's the fastest way to get all the Hawaii Open Data into Ruby (or JSON).

Read the first of two or three tutorials here:
* [Introducing the Hawaii Data Pipeline](http://pasdechocolat.com/2013/04/06/introducing-the-hawaii-data-pipeline/) - An introduction to this tool, and how to get started.
* [The Pipeline Works or Honolulu Too](http://pasdechocolat.com/2013/04/07/pipeline-for-honolulu-too/) - The tool also works for City of Honolulu data too, find out how to switch datasets.
* [Using D3.js in Hawaii](http://pasdechocolat.com/2013/04/08/using-d3-in-hawaii/) - D3 is a great tool for making data visualizations. This tutorial teaches you how to mix D3 with Hawaii Open Data.
* [Mapping Hawaii](http://pasdechocolat.com/2013/05/03/mapping-hawaii/) - Find out how to create your own custom SVG maps of Hawaii. You'll start with open source shapefiles and travel through TopoJSON, finally ending up with D3 plots of your points of interest.

## Requirements

* Ruby version >= 1.9
* A sense of humor.

## Getting Started

````ruby
$ (clone this repo)
$ cd (this repo)
$ cp config/config.template.yml config/config.yml
$ (edit config/config.yml to include your Socrata API App Token)
$ irb -r './client.rb'

> client = HDP::Client.new 
 => #<HDPipeline::Client:0x007f8c82198b90 @user_config={:socrata=>{:app_token=>"xxxxx"}}, @config={:gov=>:state, :app_token=>"xxxxx"}>

> client.list_datasets
 ... (bit huge list: see below for example) ...

> data = client.data_for "padw-q7ep"
 => ... (big dataset as array of hashes) ...

> data[0]
 => {"year"=>"1900", "rate_per_1000_resident_population"=>"6.7"}
````

## Datasets by Index

There's also an alternate way to grab datasets by their index (in the list):

````ruby
> client.list_item_at 214
 => {:name=>"/Health/Birth-Rate-State-Of-Hawaii-1900-2011", :id=>"padw-q7ep", :index=>214}

> client.list_item_at(214)[:name]
 => "/Health/Birth-Rate-State-Of-Hawaii-1900-2011"

> data = client.data_at 214
 => [{"year"=>"1900", "rate_per_1000_resident_population"=>"6.7"},...
````

## Catalog Search

This only works for the State of Hawaii datasets.  This is not implemented for the City of Honolulu.  We require a "catalog of datasets" for this to work.

The State of Hawaii provides a lot of datasets.  You may wish to find a dataset via index or ID lookup. Or, you may with to search on name, description, or some other part of the catalog metadata.

````ruby
# Get a catalog item by index:
> i = client.catalog_at 0

# Or, get a catalog item by ID:
> i = client.catalog_at "wzeq-n5pg"

# It behaves like a Ruby Hash.
> i.keys
 => [:name, :id, :metadata, :index]

# Note, I've stuffed all the data from the API into the ":metadata" hash.

# But, it also has method access to top-level keys:
> i[:name]
 => "1. USA.gov Short Links"

> i[:id]
 => "wzeq-n5pg"

> i[:index]
 => 0

# Search by partial name of the dataset:
> list = client.catalog_with_name "EV"
...
 => [{:name=>"Hawaii EV Charging Stations 02072013"...
> list.size
 => 1

# Search by your keywords for you idea, such as a name of thing:
> list = client.catalog_search "hawaii"
 => [{:name=>"2011 Visitor Plant Inventory Hawaii"...

> list.size
 => 70

> list = client.catalog_search "budget"
 => [{:name=>"FY 12 & FY 13 CIP Budget"...

> list.size
 => 2

# General search, allows for searching by long-form descriptions:
> list = client.catalog_search "alpha designations"
 => [{:name=>"FY 12 & FY 13 CIP Budget"...

# ...searching by index:
> list = client.catalog_search 0
 => [{:name=>"1. USA.gov Short Links"...

> list.size
 => 1

# ...searching by ID:
> list = c.catalog_search "wzeq-n5pg"
 => [{:name=>"1. USA.gov Short Links"...

> list.size
 => 1
````

## Catalog Exploration

This only works for the State of Hawaii datasets.  This is not implemented for the City of Honolulu.  We require a "catalog of datasets" for this to work.

The State of Hawaii provides a lot of metadata for each catalog item. You can use the tool to explore this metadata.

````ruby
# Catalog items are just nomal Ruby Hash objects.
# All features of the CatalogItem (CI) module are static convenience methods for 
# parsing this metadata hash.

# The trailing "nil" just suppresses echoing of output.
> i.each {|key, value| puts "#{key} is #{value}" };nil
name is 1. USA.gov Short Links
id is wzeq-n5pg
metadata is {"system_id"=>"wzeq-n5pg"...
index is 0
 => nil

# Get at the metadata:
> i[:metadata]
 => {"system_id"=>"wzeq-n5pg"...

# Find all the columns in this dataset:
> CI.columns i
 => [{"id"=>2802619,...}]

# List columns by name:
> CI.column_names i
 => ["short_url", "user_agent", "country_code", "known_user", "global_bitly_hash", "user_bitly_hash", "user_login", "short_url_cname", "referring_url", "long_url", "timestamp", "geo_region", "location", "city", "timezone", "hash_timestamp", "language"]

# List columns by display names:
> CI.column_display_names i
 => ["Short URL", "User Agent", "Country Code", "Known User", "Global Bitly Hash", "User Bitly Hash", "User Login", "Short URL CNAME", "Referring URL", "Long URL", "Timestamp", "Geo Region", "Location", "City", "Timezone", "Hash Timestamp", "Language"]

# Look up metadata on column by name:
> CI.column i, "short_url"
 => [{"id"=>2802619, "name"=>"Short URL", "dataTypeName"=>"url", "fieldName"=>"short_url", "position"=>2, "renderTypeName"=>"url", "tableColumnId"=>1502687, "width"=>208, "format"=>{}, "subColumnTypes"=>["url", "description"]}]

# Look up metadata on column by field (display) name:
> CI.column i, "Short URL"
 => [{"id"=>2802619, "name"=>"Short URL"...}]

# Look up metadata on column by ID:
> CI.column i, 2802619
 => [{"id"=>2802619, "name"=>"Short URL"...}]

# Search for column by part of the column name:
> cols = CI.column_like i, "url"
 => [{"id"=>2802619, "name"=>"Short URL"...

> cols.size
 => 4
````

You can begin to see the power of searching through the metadata for each catalog item, when you consider that we might match datasets together based on similar column types (such as latitude and longitude).


## What could this possibly be good for?

It's difficult to explain this, as there are folks who will see immediate value here and those who do not. If you do not, it's probably because you aren't sure how exactly to work with all this data. Rest assured, if you find yourself working with **more than one** dataset at a time, you'll want something more than a mouse to help you.

You'll probably want something that looks like this tool right here. This isn't the only way to solve this problem. How about writing something with Clojure? Haskell?

In the future I'd like to (possibly):

- [ ] Add **charts** and **maps** to the dataset catalog.
- [ ] Allow searching for datasets with matching column types.
- [ ] Allow composition of multiple datasets, based on shared column types.
- [ ] Generate simple D3 charts for basic datasets.
- [ ] Generate simple D3 maps for basic datasets (which include lat/long info).

Enjoy!


# CITY OF HONOLULU DATASETS

<pre>
client.set_dataset_type :city
client.list_datasets
 => ...
0) Name: /Finance/City-FY14-Proposed  ID: rh9s-z3mn
1) Name: /Transportation/Bike-Rack-Locations-By-Area  ID: ab7c-s2jr
2) Name: /dataset/2012-Dec-Top-Ten-Sites  ID: 7kck-y29a
3) Name: /dataset/Automated-external-defibrillator-Locations  ID: 2swm-eusf
4) Name: /dataset/City-spending  ID: std8-yakc
5) Name: /dataset/Crime-Incidents  ID: a96q-gyhq
6) Name: /dataset/Data-Catalog  ID: a3ah-kpkr
7) Name: /dataset/HART-Proposed-Budget-2012  ID: ifzd-2k3p
8) Name: /dataset/Honolulu-311-Reports  ID: fdx8-nih6
9) Name: /dataset/Neighborhood-Boards  ID: 3dxw-z8rr
10) Name: /dataset/Neighborhood-Boards-Election-2011  ID: w4ir-s4fd
11) Name: /dataset/Public-Art  ID: yef5-h88r
12) Name: /dataset/Sister-Cities  ID: pvti-pwka
13) Name: /dataset/Templates  ID: t6ff-mewd
14) Name: /dataset/Traffic-Camera-Locations  ID: dcdf-43kn
15) Name: /dataset/Traffic-Incidents  ID: ix32-iw26
 => nil
</pre>

# STATE OF HAWAII DATASETS

<pre>
client.set_dataset_type :state
client.list_datasets
 => ...
Search complete, found 381 datasets.
0) Name: 1. USA.gov Short Links  ID: wzeq-n5pg
1) Name: 2.1d VSAT Recommend Molokai By MMA  ID: htqt-4ghe
2) Name: 2007 Instructional Letters  ID: uj9h-52f4
3) Name: 2007-2008 National Voter Registration Act of 1993 Survey Combined Section A  ID: uwr9-2a69
4) Name: 2008 Election Administration and Voting Survey Combined Section C  ID: rk83-5bqj
5) Name: 2008 Election Administration and Voting Survey Combined Section C, D, E, F, F7, F7i, F8  ID: 2uw3-qc9y
6) Name: 2008 Election Administration and Voting Survey Combined Section D  ID: 7jjx-d6en
7) Name: 2008 Election Administration and Voting Survey Combined Section E  ID: p332-7rv5
8) Name: 2008 Election Administration and Voting Survey Combined Section F  ID: jb3m-y7i7
9) Name: 2008 Election Administration and Voting Survey Combined Section F7  ID: xm3x-qbi7
10) Name: 2008 Election Administration and Voting Survey Combined Section F7I  ID: 66b6-term
11) Name: 2008 Election Administration and Voting Survey Combined Section F8  ID: 6mia-nc6j
12) Name: 2008 Uniformed and Overseas Citizens Absentee Voting Act Survey Combined Section B  ID: 2tan-w4es
13) Name: 2009 Instructional Letters  ID: pj69-ay3t
14) Name: 2009-2010 National Voter Registration Act of 1993 Survey  ID: xsr6-x4pr
15) Name: 2011 Data Book Sections And Tables  ID: w28j-r29d
16) Name: 2011 Visitor Plant Inventory Hawaii  ID: rjmg-cpq7
17) Name: 2011-2012 LOBBYIST and ORGANIZATIONS  ID: n6vu-fqwd
18) Name: 2012 Instructional Letters  ID: qpxs-gtjv
19) Name: 2013 CIP Encumbrances  ID: p6rw-tx3z
20) Name: 2013 State Holidays  ID: epj5-jxdm
21) Name: 2013-2014 LOBBYIST and ORGANIZATIONS  ID: wh8j-hrn4
22) Name: 20130423 ERP STAFF AND INTERESTED PARTIES  ID: 8pbp-ehn6
23) Name: 2014 State Holidays  ID: rcfm-5fv2
24) Name: AAA Fuel Prices  ID: dqp6-3idi
25) Name: Ability To Speak English By Age  ID: ri9m-brxc
26) Name: Ability To Speak English By Gender  ID: y2i2-mgg7
27) Name: Ability To Speak English By Language  ID: 8jzv-99pp
28) Name: Ability To Speak English By Marital Status  ID: 6jpf-s9b3
29) Name: Ability To Speak English By Nativity  ID: u5ff-xh5k
30) Name: Ability To Speak English By Race  ID: avad-trha
31) Name: Ability To Speak English By Total Income  ID: wwsw-d6qv
32) Name: Achievement Results for State Assessments in Mathematics:  School Year 2008-09  ID: jie4-w22m
33) Name: Achievement Results for State Assessments in Mathematics:  School Year 2009-10  ID: hhtw-4eb7
34) Name: Achievement Results for State Assessments in Mathematics:  School Year 2010-11  ID: r3ix-z65i
35) Name: Achievement Results for State Assessments in Reading/Language Arts:  School Year 2008-09  ID: mvz4-m3zh
36) Name: Achievement Results for State Assessments in Reading/Language Arts:  School Year 2009-10  ID: s5rp-twp9
37) Name: Achievement Results for State Assessments in Reading/Language Arts:  School Year 2010-11  ID: 6qru-yfc5
38) Name: Adjusted Cohort Graduation Rates at the school level: School Year 2010-11  ID: m5pw-2ea9
39) Name: Adult Day Health Center facilities  ID: kahi-xnwd
40) Name: Adult Residential Care Home LISTING  ID: e7u9-uyxu
41) Name: Alcohol and Drug Abuse Prevention Services  ID: 2dr7-mwnn
42) Name: Alt Energy Station Data  ID: 36sn-6y6i
43) Name: Ambulatory Surgical Centers  ID: h965-zk9w
44) Name: Annual Production Figures of United States Currency  ID: ym8u-jtw3
45) Name: Assisted Living Facilities Listing  ID: iqpn-unzm
46) Name: Bills Passed 2012  ID: 86eu-zw2n
47) Name: Bills That Passed 2013 Legislature  ID: pkba-543m
48) Name: Birth Rate, State Of Hawaii 1900 - 2011  ID: padw-q7ep
49) Name: Blog Posts  ID: 53b5-749p
50) Name: CIP Encumberances June 2012  ID: aybr-r7va
51) Name: CIP Expenditures  ID: 54sf-nz6w
52) Name: Campaign Contributions Made To Candidates By Hawaii Noncandidate Committees From January 1, 2008 Through December 31, 2012  ID: 6huc-dcuw
53) Name: Campaign Contributions Received By Hawaii State and County Candidates From November 8, 2006 Through December 31, 2012  ID: jexd-xbcg
54) Name: Cash and Payments Management Data  ID: w9zu-5ne2
55) Name: Catalog of Federal Domestic Assistance (CFDA) (Old) (Old) (Old) (Old)  ID: mwm2-x6y4
56) Name: Category Information  ID: yv27-ghxi
57) Name: Category Stories  ID: p46r-d2ir
58) Name: Central Contractor Registration (CCR) FOIA Extract  ID: 3hqn-qzh6
59) Name: Civil Unions YTD 2012  ID: jjmh-uh4q
60) Name: Class Specification And Minimum Qualification  ID: b6h2-ri5e
61) Name: Contributions Received By Hawaii Noncandidate Committees From January 1, 2008 Through December 31, 2012  ID: rajm-32md
62) Name: Current TRI Chemical List  ID: gjp3-95wf
63) Name: DBEDT Average Annual Regular Gasoline Price Hawaii Vs U. S. 2006-2010  ID: fsqf-xf57
64) Name: DBEDT Average Monthly Regular Gasoline Price Hawaii Vs U. S. 2006-2010  ID: 9zb8-378h
65) Name: DBEDT Average Monthly Regular Gasoline Prices Hawaii (by County) Vs US  ID: f55i-85xa
66) Name: DBEDT Clean Economy Job Growth 2003-2010  ID: 5fix-ixwc
67) Name: DBEDT Cost Of Electricity For State Agencies FY05- FY10  ID: igkv-isiz
68) Name: DBEDT Cost Of Electricity For State Agencies by Fiscal Year  ID: x7ms-76ef
69) Name: DBEDT Cumulative Installed Photovoltaic Capacity Per Capita  ID: t9ac-479g
70) Name: DBEDT Currently Proposed Renewable Energy Projects In Hawaii  ID: b8it-cxyb
71) Name: DBEDT Electricity Consumption By State Agencies FY05- FY10  ID: 64np-vcjy
72) Name: DBEDT Energy Savings Performance Contracting Per Capita  ID: vad7-tbnj
73) Name: DBEDT HECO Ranks Third In 2010 Annual Solar Watts Per Customer  ID: jyvh-hvkp
74) Name: DBEDT Hawaii Annual Electricity Cost  ID: i7am-7q95
75) Name: DBEDT Hawaii Annual Electricity Cost And Consumption 2006-2010  ID: dnwk-g44q
76) Name: DBEDT Hawaii Cumulative Hybrid And Electric Vehicles Registered 2000-2010  ID: wget-66q5
77) Name: DBEDT Hawaii De Facto Population By County 2000-2010  ID: i7pr-uy4x
78) Name: DBEDT Hawaii Electricity Consumption  ID: ya75-e6j8
79) Name: DBEDT Hawaii Electricity Consumption  ID: qqqb-dua6
80) Name: DBEDT Hawaii Electricity Consumption 1970-2010  ID: qs2r-yxun
81) Name: DBEDT Hawaii Energy Efficiency Improvements 2005-2010  ID: a7ub-k7sa
82) Name: DBEDT Hawaii Energy Star Buildings 2003-2011  ID: vd5c-qe52
83) Name: DBEDT Hawaii Fossil Fuel Consumption And Expenditures 1970-2009  ID: 2u2g-c52b
84) Name: DBEDT Hawaii Nominal Gross Domestic Product 2000-2010  ID: s3qd-f86n
85) Name: DBEDT Hawaii Renewable Energy Generation 2005-2010  ID: vvr4-p4an
86) Name: DBEDT Hawaii Renewable Energy Generation By Resource  ID: ezj8-myxp
87) Name: DBEDT Hawaii State Agencies Electricity Consumption And Cost  ID: xpcc-ct2d
88) Name: DBEDT Hawaii State Agencies Electricity Consumption And Cost FY05- FY10  ID: bubj-tpbw
89) Name: DBEDT Hawaii Utility Companies Rank Among The Top  ID: i2tt-ek6x
90) Name: DBEDT Hawaii Utility Companies Rank Among The Top In Cumulative Solar Watts Per Customer  ID: kbgq-sdh2
91) Name: DBEDT Hawaii Vehicle Miles Traveled 1990-2010  ID: 894w-927z
92) Name: DBEDT Hawaii's Clean Economy Job Growth  ID: d3e2-v3mh
93) Name: DBEDT New Distributed Renewable Energy Systems Installed In Hawaii Annually  ID: y7ur-vi2p
94) Name: DBEDT New Distributed Renewable Energy Systems Installed In Hawaii Annually 2001-2010  ID: mp64-qiad
95) Name: DBEDT Pie Chart Of Electric Hybrid Fossil Cars  ID: hm88-midt
96) Name: DBEDT Solar- Related Construction Expenditures As A Percent Of Total Expenditures  ID: 7cps-5y5m
97) Name: DHHL General Leases  ID: i7f9-fj37
98) Name: DHHL Licenses  ID: vcvt-yznb
99) Name: DHHL Revocable Permits  ID: j5dq-nmjy
100) Name: DHHL Right Of Entry  ID: jpyg-5jmy
101) Name: DOH CAMHD  ID: m659-q5bd
102) Name: Data.gov Daily Visitor Statistics  ID: bmze-gihd
103) Name: Data.gov Dataset Monthly Download Trends  ID: vx25-4bgc
104) Name: Data.gov Datasets Download By Data Category  ID: hhjs-7smp
105) Name: Data.gov Datasets Uploaded by Agencies per month  ID: 7vpv-axhc
106) Name: Data.gov Federal Agency Participation  ID: aubg-mfc9
107) Name: Data.gov Monthly Page Views  ID: spus-5492
108) Name: Data.gov Monthly Visitor Statistics  ID: 9car-pxwp
109) Name: Data.gov Top 10 Visiting Countries  ID: czf7-qvqf
110) Name: Data.gov Top 10 Visiting States  ID: we7r-hu8x
111) Name: Death Rate, State Of Hawaii 1900 - 2011  ID: xa5e-sayp
112) Name: December 2012 Encumbrances  ID: 9j5e-h438
113) Name: Department of Defense - State Civil Defense Emergency Siren Locations  ID: jety-j7dm
114) Name: Department of Defense Hawaii Air National Guard  ID: Enter a resource name
115) Name: Department of Defense Hawaii Army National Guard Facility Locations  ID: 9ms4-cvz7
116) Name: Department of State Voting Assistance Officer 2008 Post Election Survey  ID: szft-5daq
117) Name: Dialysis Centers  ID: bcw9-zb3y
118) Name: Distinct agency names in geospatial metadata  ID: 6mq7-82cd
119) Name: Durable Assets For Hawaii Noncandidate Committees From January 1, 2008 Through December 31, 2012  ID: i778-my94
120) Name: Durable Assets For Hawaii State and County Candidates From November 8, 2006 Through December 31, 2012  ID: fmfj-bac2
121) Name: EPA Toxics Release Inventory Program  ID: wma8-v5fi
122) Name: Early Learning  ID: tnnx-zerc
123) Name: Excess Federal Properties  ID: fwrd-p9ax
124) Name: Executive Orders from 1994 to 2012  ID: ps37-i6ce
125) Name: Expenditures Made By Hawaii Noncandidate Committees From January 1, 2008 Through December 31, 2012  ID: riiu-7d4b
126) Name: Expenditures Made By Hawaii State and County Candidates From November 8, 2006 Through December 31, 2012  ID: 3maa-4fgr
127) Name: Export-Import FY 2007 Applications  ID: b522-5988
128) Name: Export-Import FY 2007 Participants  ID: 94s7-8bc4
129) Name: Export-Import FY 2008 Applications  ID: x5yb-3m6g
130) Name: Export-Import FY 2008 Participants  ID: qmg4-28c7
131) Name: Export-Import FY 2009 Applications  ID: qjfq-7m95
132) Name: Export-Import FY 2009 Participants  ID: w4ju-iurc
133) Name: Export-Import FY 2010 Applications  ID: de9r-6tze
134) Name: Export-Import FY 2010 Participants  ID: xegi-46pm
135) Name: Export-Import FY 2011 Applications  ID: 7gs4-396b
136) Name: Export-Import FY 2011 Participants  ID: mdvf-68cr
137) Name: Export-Import FY 2012 Applications  ID: a84i-8kb5
138) Name: Export-Import FY 2012 Participants  ID: em83-2ywi
139) Name: Export-Import FY 2013 Applications  ID: jki6-u4jp
140) Name: Export-Import FY 2013 Participants  ID: yhdt-apb3
141) Name: FARA Records  ID: fara-registrations
142) Name: FAS Forecast Of Contracting Opportunities  ID: e6hw-q8rb
143) Name: FEC Candidates  ID: fec-candidate
144) Name: FEC Committees  ID: fec-committee
145) Name: FEC Contributions  ID: 4dkz-64bn
146) Name: FY 12 & FY 13 CIP Budget  ID: dkm3-39id
147) Name: FY 13 Operating Budget By Cost Element (w. SUB)  ID: pi3x-y834
148) Name: FY2013 Per Diem Reimbursement Rates  ID: perdiem
149) Name: Family Guidance Centers  ID: uv73-kg72
150) Name: Family Guidance Centers  ID: vr34-rcsa
151) Name: Federal Acquisition Service Instructional Letter 2008  ID: uqka-e8rd
152) Name: Federal Acquisition Service Instructional Letter 2010  ID: in27-bzp2
153) Name: Federal Acquisition Service Instructional Letter 2011  ID: gxu5-zmjz
154) Name: Federal Advisory Committee Act (FACA) Committee Member List-1997  ID: fext-zxex
155) Name: Federal Advisory Committee Act (FACA) Committee Member List-1998  ID: zx26-9ui3
156) Name: Federal Advisory Committee Act (FACA) Committee Member List-1999  ID: 3ne8-smp5
157) Name: Federal Advisory Committee Act (FACA) Committee Member List-2000  ID: 9rrm-cghv
158) Name: Federal Advisory Committee Act (FACA) Committee Member List-2001  ID: tvsq-mxeu
159) Name: Federal Advisory Committee Act (FACA) Committee Member List-2002  ID: z8t4-b33c
160) Name: Federal Advisory Committee Act (FACA) Committee Member List-2003  ID: kxci-9zen
161) Name: Federal Advisory Committee Act (FACA) Committee Member List-2004  ID: uwfv-c5g3
162) Name: Federal Advisory Committee Act (FACA) Committee Member List-2005  ID: 7ji5-mpn9
163) Name: Federal Advisory Committee Act (FACA) Committee Member List-2006  ID: e2uu-kmyn
164) Name: Federal Advisory Committee Act (FACA) Committee Member List-2007  ID: 3wwp-fssc
165) Name: Federal Advisory Committee Act (FACA) Committee Member List-2008  ID: b348-risj
166) Name: Federal Cost of School Food Program Data  ID: ysmn-j7g2
167) Name: Federal Data Center Consolidation Initiative (FDCCI) Data Center Closings 2010-2013  ID: d5wm-4c37
168) Name: Federal Employees Living Overseas 2008 Post Election Survey  ID: mgvs-6quj
169) Name: Federal Executive Agency Internet Domains as of  05/14/2013  ID: ku4m-7ynp
170) Name: First In Nation Energy Savings Performance Contracting Per Capita  ID: my42-pfm5
171) Name: Fiscal Year 2006 Employee & Survivor Annuitants by Geographic Distribution  ID: cbz3-q4aw
172) Name: Food Plate Data  ID: foods
173) Name: Foreign Per Diem Rates by Location  ID: jf5a-mh6t
174) Name: Free Standing X-Ray Facility  ID: xpu9-ny5u
175) Name: GSA PBS Environmental Risk Index (ERIN)  ID: 8y72-wbpt
176) Name: General Election 2010 Summary Results.csv  ID: 8bdn-x7b5
177) Name: General Election 2012 Results  ID: eze4-hq7j
178) Name: General Election 2012 Summary Results  ID: gvfi-8e84
179) Name: General Election Results 2010  ID: y7za-qz47
180) Name: Grand Traverse Overall Supply Air Monitoring  ID: v7h3-9e9g
181) Name: Green Jobs By Industry  ID: grte-hrwt
182) Name: HAWAII'S FARMER'S MARKET  ID: nqfm-3etr
183) Name: HI Electricity Prices  ID: 74g9-vewt
184) Name: HI KWh Utility Supply 2008 - 2012  ID: raj6-dc7s
185) Name: HSEC- Organizations Expenditures (2006-2012)  ID: 6uwv-4qkz
186) Name: Hawaii Annual Electricity Consumption  ID: biet-37vh
187) Name: Hawaii County Births, Deaths, Marriages, Civil Unions 2012  ID: q8kg-9myh
188) Name: Hawaii County TEFAP Agencies  ID: u2s9-2pv4
189) Name: Hawaii Directory Of Green Employers  ID: mq86-5ta6
190) Name: Hawaii EV Charging Stations 02072013  ID: hbhw-unm4
191) Name: Hawaii Public Schools  ID: 6r5m-ppsj
192) Name: Hawaii Training Providers 2011  ID: 365y-wu3m
193) Name: Hawaii eGov Apps  ID: y552-5npg
194) Name: Hawaii's Registered Livestock Brands  ID: gqi6-9ts8
195) Name: Home Health Agencies  ID: 3ekp-jm2z
196) Name: Honolulu County Births, Deaths, Marriages, Civil Unions 2012  ID: bxc7-28ys
197) Name: Hospice Facilities  ID: c6z7-qg9b
198) Name: Hospitals in Hawaii  ID: rwns-g4bn
199) Name: IC2011 ODI  ID: wjms-uqtz
200) Name: IC2012 ODI  ID: ick7-necg
201) Name: IC2013 ODI  ID: bemv-9rsd
202) Name: Initial Conferences Held ( RSN 39973)  ID: yrmn-32dg
203) Name: Interactive Datasets on Data.gov  ID: 2hpy-4cgt
204) Name: Inventory Reporting Information System (IRIS) Safety  ID: 3myt-pfx4
205) Name: Investing In Innovation 2010 Applications  ID: qk9j-ipa4
206) Name: Investing In Innovation 2011 Applications  ID: svh6-9cag
207) Name: Kauai County Births, Deaths, Marriages, Civil Unions 2012  ID: u2ph-i4am
208) Name: Kauai TEFAP Agencies  ID: 92m2-d339
209) Name: LICENSED PESTICIDES LISTING  ID: rzjk-9g6v
210) Name: Libraries Annual Statistics Comparison 2010-2011  ID: utt5-rg7n
211) Name: Libraries Blind And Physically Handicapped Fiscal 2011  ID: nd3u-89v6
212) Name: Libraries Borrowers 1984 - 2011  ID: uzs2-uayh
213) Name: Libraries Circulation Activity 1984 - 2011  ID: ky64-e4mx
214) Name: Libraries Collection Statistics 2011  ID: acuw-fgkq
215) Name: Libraries Collections Statistics 2005-2011  ID: g4rv-58tp
216) Name: Libraries Computers Available  ID: tkwq-e4vi
217) Name: Libraries Expenditures FY2007 - FY2010  ID: cqxe-ukdd
218) Name: Libraries Holdings 1984 - 2011  ID: rdtc-xuie
219) Name: Libraries Holdings FY84 - FY12  ID: n84k-kyxx
220) Name: Libraries Hosted Programs FY2009 - FY2011  ID: 3af5-md85
221) Name: Libraries Internet Sessions By Year FY06 - FY11  ID: e85y-zk7s
222) Name: Libraries Material Inventory 2005 - 2012  ID: cip4-gcsk
223) Name: Libraries Outreach Programs FY2009 - FY2011  ID: ekm4-ugtg
224) Name: Libraries State Of Hawaii  ID: jx86-2vch
225) Name: Licensed Intermediate Care Facilities  ID: 3zrt-yrqs
226) Name: Loans Received By Hawaii State and County Candidates From November 8, 2006 Through December 31, 2012  ID: yf4f-x3r4
227) Name: Lobbying Disclosure Reports  ID: congressional-lobbying
228) Name: Local Education Agency (School District) Universe Survey Data 2009-10  ID: t9x5-2xzp
229) Name: Local Election Official 2008 Post Election Survey  ID: bwb6-fcji
230) Name: Marine Casualty and Pollution Database - Facility Pollution for 2002-2010  ID: wxch-i4p2
231) Name: Marine Casualty and Pollution Database - Injury for 2002 - 2010  ID: atbs-jds5
232) Name: Marine Casualty and Pollution Database - Other Events for 2002 - 2010  ID: 9jm7-jmx8
233) Name: Marine Casualty and Pollution Database - Vessel 2002-2010  ID: 8gap-yij5
234) Name: Marine Casualty and Pollution Database - Vessel Events for 2002-2010  ID: vf29-pk33
235) Name: Marine Casualty and Pollution Database - Vessel Pollution for 2002-2010  ID: g66d-8aji
236) Name: Materials Discarded in the U.S. Municipal Waste Stream, 1960 to 2009 (in tons)  ID: 3g88-w2ag
237) Name: Maui County Births, Deaths, Marriages, Civil Unions 2012  ID: rt4b-b8s5
238) Name: Maui County TEFAP Agencies  ID: ww8h-8rsi
239) Name: Monthly Economic Indicators - State Of Hawaii  ID: f96m-3kf5
240) Name: Motions Hearings Held ( RSN 39976)  ID: c5n8-8cmk
241) Name: Non-federal employees living overseas 2008 Post Election Survey  ID: njp2-ckqg
242) Name: Non-resident Marriages 2012  ID: nu5e-s79u
243) Name: Number of Appeals ( RSN 39972)  ID: 6yqr-w4bm
244) Name: OAHU Food Establishments  ID: qkvm-skze
245) Name: OGE Travel Reports  ID: oge-travel-reports
246) Name: OIE-FAVN TEST RESULTS BY MICROCHIP - under construction with test data  ID: fhan-ym2j
247) Name: OIP Master UIPA Records Request Semiannual Log For FY2013  ID: mt2n-teu8
248) Name: Oahu TEFAP Agencies  ID: e4jf-2nsz
249) Name: October 2012 Encumbrances  ID: avhv-dnmd
250) Name: Organ Procurement facilities  ID: 678g-isej
251) Name: Other Receipts For Hawaii Noncandidate Committees From January 1, 2008 Through December 31, 2012  ID: m822-j8iy
252) Name: Other Receipts For Hawaii State and County Candidates From November 8, 2006 Through December 31, 2012  ID: ue3d-efjr
253) Name: Outpatient Physical therapy locations  ID: 3gh2-6seg
254) Name: Post-Secondary Universe Survey 2010 - Awards/degrees conferred by program, award level, race/ethnicity, and gender  ID: fjce-ze3t
255) Name: Post-Secondary Universe Survey 2010 - Directory information  ID: uc4u-xdrd
256) Name: Post-Secondary Universe Survey 2010 - Educational offerings and athletic associations  ID: 5uik-y7st
257) Name: Post-Secondary Universe Survey 2010 - Student charges by program (vocational programs)  ID: tcb6-vjfn
258) Name: Post-Secondary Universe Survey 2010 - Student charges for academic year programs  ID: wgh7-hitc
259) Name: Primary Election Precinct Results 2012  ID: dmak-5fr2
260) Name: Primary Election Summary Results 2012  ID: gaj3-6934
261) Name: Promise Neighborhood 2010 Applications  ID: tx6j-n43f
262) Name: Promise Neighborhoods 2011 Applications  ID: v8dy-34yh
263) Name: Promise Neighborhoods 2011 Grantees  ID: 7tzs-hvnp
264) Name: Public Charging Stations in Hawaii  ID: 95x5-qrxh
265) Name: Public Elementary/Secondary School Universe Survey 2009-10  ID: school
266) Name: Public Health Nursing Listing  ID: x8h7-p5cj
267) Name: Ready to Learn 2010 Applicants  ID: xtr2-xtwh
268) Name: Report Card 1:  Overall Hawaii Visitor Numbers  ID: puxz-9rab
269) Name: Report Card 2.1a VSAT Recommend Statewide By MMA  ID: 787x-dmw4
270) Name: Report Card 2.1b VSAT Recommend Oahu By MMA  ID: ajhw-3huu
271) Name: Report Card 2.1c VSAT Recommend Maui By MMA  ID: 2g7t-6bmg
272) Name: Report Card 2.1e VSAT Recommend Lanai By MMA  ID: uu3p-zrur
273) Name: Report Card 2.1f VSAT Recommend Kauai By MMA  ID: 525d-apk2
274) Name: Report Card 2.1g VSAT Recommend Big Island By MMA  ID: 8v3f-iwvf
275) Name: Report Card 2.2a VSAT Return Statewide By MMA  ID: cwzq-rpan
276) Name: Report Card 2.3a VSAT Expectations Statewide By MMA  ID: 7n2q-gb7g
277) Name: Report Card 2b VSAT Overall Satisfaction Oahu By MMA  ID: j7f6-dpfq
278) Name: Report Card 2c VSAT Overall Satisfaction Maui By MMA  ID: 7rff-hkaj
279) Name: Report Card 2d VSAT Overall Satisfaction Molokai By MMA  ID: 3exa-uvbq
280) Name: Report Card 2e VSAT Overall Satisfaction Lanai By MMA  ID: wyyg-zvvt
281) Name: Report Card 2f VSAT Overall Satisfaction Kauai By MMA  ID: mvkv-3dke
282) Name: Report Card 2g VSAT Overall Satisfaction Hawaii Island By MMA  ID: qqa6-5vvy
283) Name: Report Card 3a Resident Sentiment Benefits  ID: i58n-7utq
284) Name: Report Card 3b Resident Sentiment Tourism for Family  ID: 3nqr-pbqh
285) Name: Report Card 3c Resident Sentiment Island Economy  ID: xrap-ydyp
286) Name: Report Card 3d Resident Sentiment Island Expense Locals  ID: jxj3-wzqf
287) Name: Report Card 3e Resident Sentiment Quality of Life  ID: asy7-es7y
288) Name: Report Card 3f Resident Sentiment Govt Promote  ID: mjna-b9qt
289) Name: Report Card 3g Resident Sentiment Jobs  ID: 3nah-v3qi
290) Name: Report Card 3h Resident Sentiment Treatment  ID: sudc-h239
291) Name: Report Card 3i Resident Sentiment Resources  ID: 69kz-wks8
292) Name: Report Card 4a Tax Visitor Expenditures  ID: jaz3-xs6b
293) Name: Report Card 4b Tax Tax Revenues From Visitor Expenditures  ID: nit8-gtva
294) Name: Report Card 4c Tax TAT  ID: qs2i-nbst
295) Name: Rural Health Clinics  ID: map3-5ue5
296) Name: SEALS OF QUALITY  ID: usck-9d9m
297) Name: SOI County-to-County Inflow Migration Data, 2004-2010  ID: qjy6-p5ad
298) Name: SOI County-to-County Outflow Migration Data, 2004-2010  ID: ixnw-g23j
299) Name: STD HIV Clinic  ID: gbu4-vtbs
300) Name: Sample OIP Master UIPA Records Request Log For All Agencies  ID: emfc-dtj9
301) Name: School Improvement 2010 Grants  ID: tft7-e3rz
302) Name: September 2012 Encumbrances  ID: 8st4-pkf9
303) Name: Settlement And Status Conferences Held ( RSN 39974)  ID: kqr4-b9tu
304) Name: Skilled Nursing Care Facilities  ID: 67hh-8zm9
305) Name: Slideshow Content  ID: 7dae-bjqc
306) Name: State Civil Defense Hurricane Shelters  ID: vae6-r73i
307) Name: State of Hawaii Elected Officials  ID: m6cf-4bb7
308) Name: State of Hawaii Open Data growth  ID: berr-farz
309) Name: Statewide Births, Deaths, Marriages, Civil Unions 2012  ID: bhtq-x545
310) Name: Statewide Food Est List11-2011  ID: 9ekn-r3cm
311) Name: System for Tracking and Administering Real-property (STAR) Inventory Buildings  ID: 843a-3ptd
312) Name: System for Tracking and Administering Real-property (STAR) Lease  ID: gwmg-y96b
313) Name: TAX 12 2012  Liquid Fuel Collections  ID: 36ik-4uk9
314) Name: TAX 12 2012 Liquid Fuel Allocations  ID: cbix-g738
315) Name: TAX 12-2012 LIQUID FUEL RATE SCHEDULE  ID: ap2e-c6eb
316) Name: TAX 12-2012 Liquor Collections And Permits  ID: c44e-iar7
317) Name: TAX 12-2012 Tobacco Tax Collections  ID: 42id-b4fw
318) Name: TSCA Inventory  ID: cq6u-d4uv
319) Name: Table 1.06 RESIDENT POPULATION, BY COUNTY 1990 TO 2011 (as Of July 1)  ID: hnpb-2rfi
320) Name: Table 1.09 DE FACTO POPULATION, BY COUNTY  1990 TO 2011 (as Of July 1)  ID: r7rd-74na
321) Name: Table 10.03 ACTIVE DUTY PERSONNEL, BY SERVICE 1953 TO 2011  ID: 6c7h-e33a
322) Name: Table 10: Cumulative Sanitary Surveys of Drinking Water Systems  ID: x38n-w8un
323) Name: Table 11.11 SOCIAL SECURITY BENEFICIARIES AND BENEFITS PAID 1991 TO 2010  ID: gtc6-4in2
324) Name: Table 11: Total Underground Injection Control (UIC) Permits  ID: deaj-mj5i
325) Name: Table 12.26 AVERAGE ANNUAL WAGE  IN CURRENT AND CONSTANT DOLLARS  1969 TO 2010  ID: e7p8-6b2a
326) Name: Table 12: Wastewater Treatment Plant Operations & Compliance  ID: at3v-ejzj
327) Name: Table 13.02 GROSS DOMESTIC PRODUCT, TOTAL AND PER CAPITA AND RESIDENT  ID: khmp-yavi
328) Name: Table 13.06 TOTAL AND PER CAPITA PERSONAL INCOME FOR THE UNITED STATES AND HAWAII 1969 TO 2011  ID: 5gja-rp2f
329) Name: Table 13: Wastewater Recycled  ID: 56dm-4idp
330) Name: Table 14.02 CONSUMER PRICE INDEX, FOR ALL URBAN CONSUMERS ( CPI- U), ALL ITEMS, FOR HONOLULU AND UNITED STATES  1940 TO 2011  ID: 4qc6-bjzm
331) Name: Table 14: Toxic Release Inventory (TRI) (in pounds)  ID: jhq5-pd3u
332) Name: Table 15: Oil and Chemical Releases  ID: yqmp-94ap
333) Name: Table 16: Solid Waste Generated Per Person (Pounds)  ID: eex2-n8qt
334) Name: Table 17.03 CONSUMPTION OF ENERGY BY END- USE SECTOR 1960 TO 2009  ID: usfi-mive
335) Name: Table 17.05 PRIMARY ENERGY CONSUMPTION, BY SOURCE  1992 TO 2010  ID: 7rq6-y7pf
336) Name: Table 17: Solid Waste Recycled (in tons)  ID: v48g-wbhi
337) Name: Table 18.07  MOTOR VEHICLES REGISTERED, BY COUNTY 1995 TO 2011  ID: jbez-8d6q
338) Name: Table 18.25 PUBLIC TRANSIT, FOR OAHU  1993 TO 2011  ID: 88uj-hez9
339) Name: Table 18: Leaking Underground Storage Tanks  ID: 5xci-hiqu
340) Name: Table 19: Hazardous Waste Generated  ID: h44e-tzy6
341) Name: Table 21.25 STATE GOVERNMENT CAPITAL IMPROVEMENT PROJECT EXPENDITURES  1990 TO 2011  ID: dyvi-h84f
342) Name: Table 23.34 VISITOR ACCOMMODATIONS, BY COUNTY  1975 TO 2011 (number Of Units)  ID: w6i2-ivxn
343) Name: Table 2: Ambient Levels of Airborne Particulates (PM) in Honolulu  ID: fn9b-s9c4
344) Name: Table 3.14 HAWAII STATE HIGH SCHOOL GRADUATES BY PUBLIC AND PRIVATE HIGH SCHOOL  ID: bvnw-4za7
345) Name: Table 3.22 HEADCOUNT ENROLLMENT AT THE UNIVERSITY OF HAWAII, BY CAMPUS  FALL 1997 TO 2011  ID: rjsa-twkk
346) Name: Table 5: Ambient Levels of Carbon Monoxide (CO) in Honolulu  ID: 5abm-p3au
347) Name: Table 6: Number of Hawaiian Coastal Waters by Island (2006)  ID: crh9-d7dx
348) Name: Table 7.03 VISITOR ARRIVALS AND AVERAGE DAILY VISITOR CENSUS 1966 TO 2011  ID: b587-guv7
349) Name: Table 7: Number of Hawaiian Perennial Streams by Island  ID: wr45-43y4
350) Name: Table 9.51 FEDERAL EXPENDITURES IN HAWAII, BY TYPE  1983 TO 2010  ID: hb24-hmx9
351) Name: Table 9: Percentage of Population served Safe Drinking Water  ID: h53f-wetv
352) Name: Table A1: Actual and Forecast of Key Economic Indicators for Hawaii: 2010 TO 2015  ID: h4a4-8vsd
353) Name: Tax Returns Processed  ID: xwuk-s2i8
354) Name: Tax Year 2007 County Income Data  ID: wvps-imhx
355) Name: Teaching American History 2010 Applicants  ID: fwe6-iczz
356) Name: Teaching American History 2010 Grantees  ID: 7ckp-dax8
357) Name: Templates  ID: templates
358) Name: Third In Nation Clean Economy Job Growth  ID: qb5w-vky4
359) Name: Third In The Nation Cumulative Installed Photovoltaic Capacity Per Capita  ID: bkbb-h3r6
360) Name: Time to Hire GSA employees  ID: 2xzh-tft9
361) Name: Top 50 Employers - Hawaii County  ID: gphu-34y5
362) Name: Top 50 Employers - Honolulu County  ID: jkm3-epq4
363) Name: Top 50 Employers - Maui County  ID: 9i8q-bgfy
364) Name: Toxics Release Inventory Chemicals by Groupings  ID: pwnn-pm3f
365) Name: Trials and Hearings De Novo Held ( RSN 39975)  ID: rd53-cm5u
366) Name: U.S. Overseas Loans and Grants (Greenbook)  ID: 668u-5wrc
367) Name: USAID Development Credit Authority Guarantee Data: Loan Transactions  ID: 7swc-ittd
368) Name: USAID Development Credit Authority Guarantee Data: Utilization and Claims  ID: atqm-5nw2
369) Name: Uniformed Voting Assistance Officers 2008 Post Election Survey  ID: q7ez-fzdd
370) Name: University of Hawaii - Degrees Awarded by Major, Gender, and Hawaiian Legacy  ID: 2xs8-cmdv
371) Name: University of Hawaii - Enrollment Demographics  ID: iyed-y2yx
372) Name: University of Hawaii - Enrollment by Zipcode  ID: mj96-8utp
373) Name: Unpaid Expenditures For Hawaii State and County Candidates From November 8, 2006 Through December 31, 2012  ID: rrkr-p5kv
374) Name: Unpaid Expenditures For Noncandidate Committees From January 1, 2008 Through December 31, 2012  ID: dq35-6ks5
375) Name: Veterans Burial Sites  ID: 9awu-hy98
376) Name: WC2011 ODI  ID: 4va6-9e4c
377) Name: WC2012 ODI  ID: anqz-y43n
378) Name: WC2013 ODI  ID: uvuu-rsxq
379) Name: WTI Barrel of Oil Future Prices  ID: jzyk-q3tp
380) Name: White House Visitor Records Requests  ID: white-house-visitor-records
 => nil
</pre>


# LICENSE

I'm using the [WTFPL](http://www.wtfpl.net "WTF Public License") for now. 

Copyright © 2013 Pas de Chocolat, LLC.
This work is free. You can redistribute it and/or modify it under the
terms of the Do What The Fuck You Want To Public License, Version 2,
as published by Sam Hocevar. See the COPYING file for more details.

This program is free software. It comes without any warranty, to
* the extent permitted by applicable law. You can redistribute it
* and/or modify it under the terms of the Do What The Fuck You Want
* To Public License, Version 2, as published by Sam Hocevar. See
* http://www.wtfpl.net/ for more details.