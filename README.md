This is the Hawaii Data Pipeline tool.  It's the fastest way to get all the Hawaii Open Data into Ruby (or JSON).

Read the first of two or three tutorials here:
http://pasdechocolat.com/2013/04/06/introducing-the-hawaii-data-pipeline/

````ruby
$ (clone this repo)
$ cd (this repo)
$ cp config/config.template.yml config/config.yml
$ (edit config/config.yml to include your Socrata API App Token)
$ irb -r './client.rb'
> client = HDPipeline::Client.new 
> client.list_datasets
> data = client.data_for "padw-q7ep"
> data[0]
````

Enjoy!

# CITY OF HONOLULU DATASETS

````ruby
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
````

# STATE OF HAWAII DATASETS

````ruby
client.set_dataset_type :state
client.list_datasets
 => ...
Search complete, found 369 datasets.
0) Name: /Banking-Finance-and-Insurance/Export-Import-FY-2006-Applications  ID: jki6-u4jp
1) Name: /Banking-Finance-and-Insurance/Export-Import-FY-2006-Participants  ID: yhdt-apb3
2) Name: /Banking-Finance-and-Insurance/Export-Import-FY-2007-Applications  ID: b522-5988
3) Name: /Banking-Finance-and-Insurance/Export-Import-FY-2007-Participants  ID: 94s7-8bc4
4) Name: /Banking-Finance-and-Insurance/Export-Import-FY-2008-Applications  ID: x5yb-3m6g
5) Name: /Banking-Finance-and-Insurance/Export-Import-FY-2008-Participants  ID: qmg4-28c7
6) Name: /Banking-Finance-and-Insurance/Export-Import-FY-2009-Applications  ID: qjfq-7m95
7) Name: /Banking-Finance-and-Insurance/Export-Import-FY-2009-Participants  ID: w4ju-iurc
8) Name: /Banking-Finance-and-Insurance/Export-Import-FY-2010-Applications  ID: de9r-6tze
9) Name: /Banking-Finance-and-Insurance/Export-Import-FY-2010-Participants  ID: xegi-46pm
10) Name: /Banking-Finance-and-Insurance/Export-Import-FY-2011-Applications  ID: 7gs4-396b
11) Name: /Banking-Finance-and-Insurance/Export-Import-FY-2011-Participants  ID: mdvf-68cr
12) Name: /Banking-Finance-and-Insurance/Export-Import-FY-2012-Applications  ID: a84i-8kb5
13) Name: /Banking-Finance-and-Insurance/Export-Import-FY-2012-Participants  ID: em83-2ywi
14) Name: /Business-Enterprise/Inventory-Reporting-Information-System-IRIS-Safety  ID: 3myt-pfx4
15) Name: /Community/Campaign-Contributions-Made-To-Candidates-By-Hawai  ID: 6huc-dcuw
16) Name: /Community/Campaign-Contributions-Received-By-Hawaii-State-an  ID: jexd-xbcg
17) Name: /Community/Contributions-Received-By-Hawaii-Noncandidate-Comm  ID: rajm-32md
18) Name: /Community/Durable-Assets-For-Hawaii-Noncandidate-Committees-  ID: i778-my94
19) Name: /Community/Durable-Assets-For-Hawaii-State-and-County-Candida  ID: fmfj-bac2
20) Name: /Community/Expenditures-Made-By-Hawaii-Noncandidate-Committee  ID: riiu-7d4b
21) Name: /Community/Expenditures-Made-By-Hawaii-State-and-County-Candi  ID: 3maa-4fgr
22) Name: /Community/Loans-Received-By-Hawaii-State-and-County-Candidat  ID: yf4f-x3r4
23) Name: /Community/Other-Receipts-For-Hawaii-Noncandidate-Committees-  ID: m822-j8iy
24) Name: /Community/Other-Receipts-For-Hawaii-State-and-County-Candida  ID: ue3d-efjr
25) Name: /Community/Unpaid-Expenditures-For-Hawaii-State-and-County-Ca  ID: rrkr-p5kv
26) Name: /Community/Unpaid-Expenditures-For-Noncandidate-Committees-Fr  ID: dq35-6ks5
27) Name: /Construction-and-Housing/System-for-Tracking-and-Administering-Real-propert  ID: gwmg-y96b
28) Name: /Construction-and-Housing/System-for-Tracking-and-Administering-Real-propert  ID: 843a-3ptd
29) Name: /Contributors/FEC-Candidates  ID: wuxv-c8xz
30) Name: /Contributors/FEC-Committees  ID: fpyy-vyfb
31) Name: /Contributors/FEC-Contributions  ID: 4dkz-64bn
32) Name: /Culture-and-Recreation/Ability-To-Speak-English-By-Age  ID: ri9m-brxc
33) Name: /Culture-and-Recreation/Ability-To-Speak-English-By-Gender  ID: y2i2-mgg7
34) Name: /Culture-and-Recreation/Ability-To-Speak-English-By-Language  ID: 8jzv-99pp
35) Name: /Culture-and-Recreation/Ability-To-Speak-English-By-Marital-Status  ID: 6jpf-s9b3
36) Name: /Culture-and-Recreation/Ability-To-Speak-English-By-Nativity  ID: u5ff-xh5k
37) Name: /Culture-and-Recreation/Ability-To-Speak-English-By-Race  ID: avad-trha
38) Name: /Culture-and-Recreation/Ability-To-Speak-English-By-Total-Income  ID: wwsw-d6qv
39) Name: /Culture-and-Recreation/Non-resident-Marriages-2012  ID: nu5e-s79u
40) Name: /Culture-and-Recreation/Table-23-34-VISITOR-ACCOMMODATIONS-BY-COUNTY-1975-  ID: w6i2-ivxn
41) Name: /Economic-Development/2011-Data-Book-Sections-And-Tables  ID: w28j-r29d
42) Name: /Economic-Development/2011-Visitor-Plant-Inventory-Hawaii  ID: rjmg-cpq7
43) Name: /Economic-Development/AAA-Fuel-Prices  ID: dqp6-3idi
44) Name: /Economic-Development/DBEDT-Average-Annual-Regular-Gasoline-Price-Hawaii  ID: fsqf-xf57
45) Name: /Economic-Development/DBEDT-Average-Monthly-Regular-Gasoline-Price-Hawai  ID: 9zb8-378h
46) Name: /Economic-Development/DBEDT-Clean-Economy-Job-Growth-2003-2010  ID: 5fix-ixwc
47) Name: /Economic-Development/DBEDT-Cost-Of-Electricity-For-State-Agencies-FY05-  ID: igkv-isiz
48) Name: /Economic-Development/DBEDT-Cost-Of-Electricity-For-State-Agencies-by-Fi  ID: x7ms-76ef
49) Name: /Economic-Development/DBEDT-Cumulative-Installed-Photovoltaic-Capacity-P  ID: t9ac-479g
50) Name: /Economic-Development/DBEDT-Currently-Proposed-Renewable-Energy-Projects  ID: b8it-cxyb
51) Name: /Economic-Development/DBEDT-Electricity-Consumption-By-State-Agencies-FY  ID: 64np-vcjy
52) Name: /Economic-Development/DBEDT-Energy-Savings-Performance-Contracting-Per-C  ID: vad7-tbnj
53) Name: /Economic-Development/DBEDT-HECO-Ranks-Third-In-2010-Annual-Solar-Watts-  ID: jyvh-hvkp
54) Name: /Economic-Development/DBEDT-Hawaii-Annual-Electricity-Cost-And-Consumpti  ID: dnwk-g44q
55) Name: /Economic-Development/DBEDT-Hawaii-Cumulative-Hybrid-And-Electric-Vehicl  ID: wget-66q5
56) Name: /Economic-Development/DBEDT-Hawaii-De-Facto-Population-By-County-2000-20  ID: i7pr-uy4x
57) Name: /Economic-Development/DBEDT-Hawaii-Electricity-Consumption-1970-2010  ID: qs2r-yxun
58) Name: /Economic-Development/DBEDT-Hawaii-Energy-Efficiency-Improvements-2005-2  ID: a7ub-k7sa
59) Name: /Economic-Development/DBEDT-Hawaii-Energy-Star-Buildings-2003-2011  ID: vd5c-qe52
60) Name: /Economic-Development/DBEDT-Hawaii-Fossil-Fuel-Consumption-And-Expenditu  ID: 2u2g-c52b
61) Name: /Economic-Development/DBEDT-Hawaii-Nominal-Gross-Domestic-Product-2000-2  ID: s3qd-f86n
62) Name: /Economic-Development/DBEDT-Hawaii-Renewable-Energy-Generation-2005-2010  ID: vvr4-p4an
63) Name: /Economic-Development/DBEDT-Hawaii-State-Agencies-Electricity-Consumptio  ID: bubj-tpbw
64) Name: /Economic-Development/DBEDT-Hawaii-Utility-Companies-Rank-Among-The-Top  ID: i2tt-ek6x
65) Name: /Economic-Development/DBEDT-Hawaii-Utility-Companies-Rank-Among-The-Top-  ID: kbgq-sdh2
66) Name: /Economic-Development/DBEDT-Hawaii-s-Clean-Economy-Job-Growth  ID: d3e2-v3mh
67) Name: /Economic-Development/DBEDT-New-Distributed-Renewable-Energy-Systems-Ins  ID: mp64-qiad
68) Name: /Economic-Development/DBEDT-Pie-Chart-Of-Electric-Hybrid-Fossil-Cars  ID: hm88-midt
69) Name: /Economic-Development/DHHL-General-Leases  ID: i7f9-fj37
70) Name: /Economic-Development/DHHL-Licenses  ID: vcvt-yznb
71) Name: /Economic-Development/DHHL-Revocable-Permits  ID: j5dq-nmjy
72) Name: /Economic-Development/DHHL-Right-Of-Entry  ID: jpyg-5jmy
73) Name: /Economic-Development/HAWAII-S-FARMER-S-MARKET  ID: nqfm-3etr
74) Name: /Economic-Development/HI-KWh-Utility-Supply-2008-2012  ID: raj6-dc7s
75) Name: /Economic-Development/Hawaii-EV-Charging-Stations-02072013  ID: hbhw-unm4
76) Name: /Economic-Development/SEALS-OF-QUALITY  ID: usck-9d9m
77) Name: /Economic-Development/Table-1-09-DE-FACTO-POPULATION-BY-COUNTY-1990-TO-2  ID: r7rd-74na
78) Name: /Economic-Development/Table-11-11-SOCIAL-SECURITY-BENEFICIARIES-AND-BENE  ID: gtc6-4in2
79) Name: /Economic-Development/Table-12-26-AVERAGE-ANNUAL-WAGE-IN-CURRENT-AND-CON  ID: e7p8-6b2a
80) Name: /Economic-Development/Table-13-02-GROSS-DOMESTIC-PRODUCT-TOTAL-AND-PER-C  ID: khmp-yavi
81) Name: /Economic-Development/Table-13-06-TOTAL-AND-PER-CAPITA-PERSONAL-INCOME-F  ID: 5gja-rp2f
82) Name: /Economic-Development/Table-14-02-CONSUMER-PRICE-INDEX-FOR-ALL-URBAN-CON  ID: 4qc6-bjzm
83) Name: /Economic-Development/Table-17-03-CONSUMPTION-OF-ENERGY-BY-END-USE-SECTO  ID: usfi-mive
84) Name: /Economic-Development/Table-17-05-PRIMARY-ENERGY-CONSUMPTION-BY-SOURCE-1  ID: 7rq6-y7pf
85) Name: /Economic-Development/Table-18-07-MOTOR-VEHICLES-REGISTERED-BY-COUNTY-19  ID: jbez-8d6q
86) Name: /Economic-Development/Table-3-14-HAWAII-STATE-HIGH-SCHOOL-GRADUATES-BY-P  ID: bvnw-4za7
87) Name: /Economic-Development/Table-3-22-HEADCOUNT-ENROLLMENT-AT-THE-UNIVERSITY-  ID: rjsa-twkk
88) Name: /Economic-Development/Table-7-03-VISITOR-ARRIVALS-AND-AVERAGE-DAILY-VISI  ID: b587-guv7
89) Name: /Economic-Development/Table-9-51-FEDERAL-EXPENDITURES-IN-HAWAII-BY-TYPE-  ID: hb24-hmx9
90) Name: /Economic-Development/WTI-Barrel-of-Oil-Future-Prices  ID: jzyk-q3tp
91) Name: /Education/Achievement-Results-for-State-Assessments-in-Mathe  ID: r3ix-z65i
92) Name: /Education/Achievement-Results-for-State-Assessments-in-Mathe  ID: hhtw-4eb7
93) Name: /Education/Achievement-Results-for-State-Assessments-in-Mathe  ID: jie4-w22m
94) Name: /Education/Achievement-Results-for-State-Assessments-in-Readi  ID: s5rp-twp9
95) Name: /Education/Achievement-Results-for-State-Assessments-in-Readi  ID: 6qru-yfc5
96) Name: /Education/Achievement-Results-for-State-Assessments-in-Readi  ID: mvz4-m3zh
97) Name: /Education/Adjusted-Cohort-Graduation-Rates-at-the-school-lev  ID: m5pw-2ea9
98) Name: /Education/Early-Learning  ID: tnnx-zerc
99) Name: /Education/Investing-In-Innovation-2010-Applications  ID: qk9j-ipa4
100) Name: /Education/Investing-In-Innovation-2011-Applications  ID: svh6-9cag
101) Name: /Education/Local-Education-Agency-School-District-Universe-Su  ID: t9x5-2xzp
102) Name: /Education/Post-Secondary-Universe-Survey-2010-Awards-degrees  ID: fjce-ze3t
103) Name: /Education/Post-Secondary-Universe-Survey-2010-Directory-info  ID: uc4u-xdrd
104) Name: /Education/Post-Secondary-Universe-Survey-2010-Educational-of  ID: 5uik-y7st
105) Name: /Education/Post-Secondary-Universe-Survey-2010-Student-charge  ID: tcb6-vjfn
106) Name: /Education/Post-Secondary-Universe-Survey-2010-Student-charge  ID: wgh7-hitc
107) Name: /Education/Promise-Neighborhood-2010-Applications  ID: tx6j-n43f
108) Name: /Education/Promise-Neighborhoods-2011-Applications  ID: v8dy-34yh
109) Name: /Education/Promise-Neighborhoods-2011-Grantees  ID: 7tzs-hvnp
110) Name: /Education/Public-Elementary-Secondary-School-Universe-Survey  ID: ykv5-fn9t
111) Name: /Education/Ready-to-Learn-2010-Applicants  ID: xtr2-xtwh
112) Name: /Education/School-Improvement-2010-Grants  ID: tft7-e3rz
113) Name: /Education/Teaching-American-History-2010-Applicants  ID: fwe6-iczz
114) Name: /Education/Teaching-American-History-2010-Grantees  ID: 7ckp-dax8
115) Name: /Elections/2007-2008-National-Voter-Registration-Act-of-1993-  ID: uwr9-2a69
116) Name: /Elections/2008-Election-Administration-and-Voting-Survey-Com  ID: 2uw3-qc9y
117) Name: /Elections/2008-Election-Administration-and-Voting-Survey-Com  ID: jb3m-y7i7
118) Name: /Elections/2009-2010-National-Voter-Registration-Act-of-1993-  ID: xsr6-x4pr
119) Name: /Elections/Department-of-State-Voting-Assistance-Officer-2008  ID: szft-5daq
120) Name: /Elections/Federal-Employees-Living-Overseas-2008-Post-Electi  ID: mgvs-6quj
121) Name: /Elections/Local-Election-Official-2008-Post-Election-Survey  ID: bwb6-fcji
122) Name: /Elections/Non-federal-employees-living-overseas-2008-Post-El  ID: njp2-ckqg
123) Name: /Elections/Uniformed-Voting-Assistance-Officers-2008-Post-Ele  ID: q7ez-fzdd
124) Name: /Employment/2013-State-Holidays  ID: epj5-jxdm
125) Name: /Employment/2014-State-Holidays  ID: rcfm-5fv2
126) Name: /Employment/Class-Specification-And-Minimum-Qualification  ID: b6h2-ri5e
127) Name: /Employment/Hawaii-Directory-Of-Green-Employers  ID: mq86-5ta6
128) Name: /Employment/IC2011-ODI  ID: wjms-uqtz
129) Name: /Employment/IC2012-ODI  ID: ick7-necg
130) Name: /Employment/IC2013-ODI  ID: bemv-9rsd
131) Name: /Employment/Top-50-Employers-Hawaii-County  ID: gphu-34y5
132) Name: /Employment/Top-50-Employers-Honolulu-County  ID: jkm3-epq4
133) Name: /Employment/Top-50-Employers-Maui-County  ID: 9i8q-bgfy
134) Name: /Employment/Trials-and-Hearings-De-Novo-Held-RSN-39975-  ID: rd53-cm5u
135) Name: /Employment/WC2011-ODI  ID: 4va6-9e4c
136) Name: /Employment/WC2012-ODI  ID: anqz-y43n
137) Name: /Employment/WC2013-ODI  ID: uvuu-rsxq
138) Name: /Energy-and-Utilities/Annual-1990-2009-Average-Electricity-Price-by-Stat  ID: ye3w-qcvg
139) Name: /Energy-and-Utilities/Annual-1990-2009-U-S-Electric-Power-Industry-Estim  ID: t6sb-8txz
140) Name: /Energy-and-Utilities/Retail-Gasoline-Prices-All-Grades-Areas-and-Formul  ID: f67a-puct
141) Name: /Energy-and-Utilities/State-Energy-Data-System-SEDS-  ID: iqcp-jsks
142) Name: /Environment/EPA-Toxics-Release-Inventory-Program  ID: wma8-v5fi
143) Name: /Environment/Grand-Traverse-Overall-Supply-Air-Monitoring  ID: v7h3-9e9g
144) Name: /Environment/Materials-Discarded-in-the-U-S-Municipal-Waste-Str  ID: 3g88-w2ag
145) Name: /Federal-Government-Finances-and-Employment/Cash-and-Payments-Management-Data  ID: w9zu-5ne2
146) Name: /Federal-Government-Finances-and-Employment/FY2013-Per-Diem-Reimbursement-Rates  ID: mu7x-xj6s
147) Name: /Federal-Government-Finances-and-Employment/Federal-Acquisition-Service-Instructional-Letter-2  ID: uqka-e8rd
148) Name: /Federal-Government-Finances-and-Employment/Federal-Acquisition-Service-Instructional-Letter-2  ID: gxu5-zmjz
149) Name: /Federal-Government-Finances-and-Employment/Federal-Acquisition-Service-Instructional-Letter-2  ID: in27-bzp2
150) Name: /Federal-Government-Finances-and-Employment/Federal-Data-Center-Consolidation-Initiative-FDCCI  ID: d5wm-4c37
151) Name: /Federal-Government-Finances-and-Employment/Federal-Executive-Agency-Internet-Domains-as-of-02  ID: ku4m-7ynp
152) Name: /Federal-Government-Finances-and-Employment/Fiscal-Year-2006-Employee-Survivor-Annuitants-by-G  ID: cbz3-q4aw
153) Name: /Federal-Government-Finances-and-Employment/Lobbying-Disclosure-Reports  ID: aqdm-v85k
154) Name: /Federal-Government-Finances-and-Employment/OGE-Travel-Reports  ID: kxfh-um2n
155) Name: /Federal-Government-Finances-and-Employment/Time-to-Hire-GSA-employees  ID: 2xzh-tft9
156) Name: /Financials/FAS-Forecast-Of-Contracting-Opportunities  ID: e6hw-q8rb
157) Name: /Foreign-Commerce-and-Aid/USAID-Development-Credit-Authority-Guarantee-Data-  ID: 7swc-ittd
158) Name: /Foreign-Commerce-and-Aid/USAID-Development-Credit-Authority-Guarantee-Data-  ID: atqm-5nw2
159) Name: /Formal-Education/Libraries-Annual-Statistics-Comparison-2010-2011  ID: utt5-rg7n
160) Name: /Formal-Education/Libraries-Blind-And-Physically-Handicapped-Fiscal-  ID: nd3u-89v6
161) Name: /Formal-Education/Libraries-Borrowers-1984-2011  ID: uzs2-uayh
162) Name: /Formal-Education/Libraries-Circulation-Activity-1984-2011  ID: ky64-e4mx
163) Name: /Formal-Education/Libraries-Collections-Statistics-2005-2011  ID: g4rv-58tp
164) Name: /Formal-Education/Libraries-Expenditures-FY2007-FY2010  ID: cqxe-ukdd
165) Name: /Formal-Education/Libraries-Holdings-1984-2011  ID: rdtc-xuie
166) Name: /Formal-Education/Libraries-Hosted-Programs-FY2009-FY2011  ID: 3af5-md85
167) Name: /Formal-Education/Libraries-Material-Inventory-2005-2012  ID: cip4-gcsk
168) Name: /Formal-Education/Libraries-Outreach-Programs-FY2009-FY2011  ID: ekm4-ugtg
169) Name: /Geography-and-Environment/GSA-PBS-Environmental-Risk-Index-ERIN-  ID: 8y72-wbpt
170) Name: /Geography-and-Environment/Marine-Casualty-and-Pollution-Database-Facility-Po  ID: wxch-i4p2
171) Name: /Geography-and-Environment/Marine-Casualty-and-Pollution-Database-Injury-for-  ID: atbs-jds5
172) Name: /Geography-and-Environment/Marine-Casualty-and-Pollution-Database-Other-Event  ID: 9jm7-jmx8
173) Name: /Geography-and-Environment/Marine-Casualty-and-Pollution-Database-Vessel-2002  ID: 8gap-yij5
174) Name: /Geography-and-Environment/Marine-Casualty-and-Pollution-Database-Vessel-Even  ID: vf29-pk33
175) Name: /Geography-and-Environment/Marine-Casualty-and-Pollution-Database-Vessel-Poll  ID: g66d-8aji
176) Name: /Geography-and-Environment/TSCA-Inventory  ID: cq6u-d4uv
177) Name: /Geography-and-Environment/Toxics-Release-Inventory-Chemicals-by-Groupings  ID: pwnn-pm3f
178) Name: /Government-Wide-Support/Bills-Passed-2012  ID: 86eu-zw2n
179) Name: /Government-Wide-Support/CIP-Encumberances-June-2012  ID: aybr-r7va
180) Name: /Government-Wide-Support/CIP-Expenditures  ID: 54sf-nz6w
181) Name: /Government-Wide-Support/December-2012-Encumbrances  ID: 9j5e-h438
182) Name: /Government-Wide-Support/FY-12-FY-13-CIP-Budget  ID: dkm3-39id
183) Name: /Government-Wide-Support/FY-13-Operating-Budget-By-Cost-Element-w-SUB-  ID: pi3x-y834
184) Name: /Government-Wide-Support/General-Election-2010-Summary-Results-csv  ID: 8bdn-x7b5
185) Name: /Government-Wide-Support/General-Election-2012-Results  ID: eze4-hq7j
186) Name: /Government-Wide-Support/General-Election-2012-Summary-Results  ID: gvfi-8e84
187) Name: /Government-Wide-Support/General-Election-Results-2010  ID: y7za-qz47
188) Name: /Government-Wide-Support/HI-Electricity-Prices  ID: 74g9-vewt
189) Name: /Government-Wide-Support/Hawaii-County-TEFAP-Agencies  ID: u2s9-2pv4
190) Name: /Government-Wide-Support/Hawaii-eGov-Apps  ID: y552-5npg
191) Name: /Government-Wide-Support/January-2013-Encumbrances  ID: p6rw-tx3z
192) Name: /Government-Wide-Support/Kauai-TEFAP-Agencies  ID: 92m2-d339
193) Name: /Government-Wide-Support/Maui-County-TEFAP-Agencies  ID: ww8h-8rsi
194) Name: /Government-Wide-Support/Monthly-Economic-Indicators-State-Of-Hawaii  ID: f96m-3kf5
195) Name: /Government-Wide-Support/Oahu-TEFAP-Agencies  ID: e4jf-2nsz
196) Name: /Government-Wide-Support/October-2012-Encumbrances  ID: avhv-dnmd
197) Name: /Government-Wide-Support/Primary-Election-Precinct-Results-2012  ID: dmak-5fr2
198) Name: /Government-Wide-Support/Primary-Election-Summary-Results-2012  ID: gaj3-6934
199) Name: /Government-Wide-Support/September-2012-Encumbrances  ID: 8st4-pkf9
200) Name: /Government-Wide-Support/State-of-Hawaii-Elected-Officials  ID: m6cf-4bb7
201) Name: /Government-Wide-Support/TAX-12-2012-LIQUID-FUEL-RATE-SCHEDULE  ID: ap2e-c6eb
202) Name: /Government-Wide-Support/TAX-12-2012-Liquid-Fuel-Allocations  ID: cbix-g738
203) Name: /Government-Wide-Support/TAX-12-2012-Liquid-Fuel-Collections  ID: 36ik-4uk9
204) Name: /Government-Wide-Support/TAX-12-2012-Liquor-Collections-And-Permits  ID: c44e-iar7
205) Name: /Government-Wide-Support/TAX-12-2012-Tobacco-Tax-Collections  ID: 42id-b4fw
206) Name: /Government-Wide-Support/Table-1-06-RESIDENT-POPULATION-BY-COUNTY-1990-TO-2  ID: hnpb-2rfi
207) Name: /Government-Wide-Support/Table-21-25-STATE-GOVERNMENT-CAPITAL-IMPROVEMENT-P  ID: dyvi-h84f
208) Name: /Health-and-Nutrition/Federal-Cost-of-School-Food-Program-Data  ID: ysmn-j7g2
209) Name: /Health/Adult-Day-Health-Center-facilities  ID: kahi-xnwd
210) Name: /Health/Adult-Residential-Care-Home-LISTING  ID: e7u9-uyxu
211) Name: /Health/Alcohol-and-Drug-Abuse-Prevention-Services  ID: 2dr7-mwnn
212) Name: /Health/Ambulatory-Surgical-Centers  ID: h965-zk9w
213) Name: /Health/Assisted-Living-Facilities-Listing  ID: iqpn-unzm
214) Name: /Health/Birth-Rate-State-Of-Hawaii-1900-2011  ID: padw-q7ep
215) Name: /Health/Civil-Unions-YTD-2012  ID: jjmh-uh4q
216) Name: /Health/DOH-CAMHD  ID: m659-q5bd
217) Name: /Health/Death-Rate-State-Of-Hawaii-1900-2011  ID: xa5e-sayp
218) Name: /Health/Dialysis-Centers  ID: bcw9-zb3y
219) Name: /Health/Family-Guidance-Centers  ID: uv73-kg72
220) Name: /Health/Family-Guidance-Centers  ID: vr34-rcsa
221) Name: /Health/Free-Standing-X-Ray-Facility  ID: xpu9-ny5u
222) Name: /Health/Hawaii-County-Births-Deaths-Marriages-Civil-Unions  ID: q8kg-9myh
223) Name: /Health/Hawaii-s-Registered-Livestock-Brands  ID: gqi6-9ts8
224) Name: /Health/Home-Health-Agencies  ID: 3ekp-jm2z
225) Name: /Health/Honolulu-County-Births-Deaths-Marriages-Civil-Unio  ID: bxc7-28ys
226) Name: /Health/Hospice-Facilities  ID: c6z7-qg9b
227) Name: /Health/Hospitals-in-Hawaii  ID: rwns-g4bn
228) Name: /Health/Kauai-County-Births-Deaths-Marriages-Civil-Unions-  ID: u2ph-i4am
229) Name: /Health/LICENSED-PESTICIDES-LISTING  ID: rzjk-9g6v
230) Name: /Health/Licensed-Intermediate-Care-Facilities  ID: 3zrt-yrqs
231) Name: /Health/Maui-County-Births-Deaths-Marriages-Civil-Unions-2  ID: rt4b-b8s5
232) Name: /Health/OAHU-Food-Establishments  ID: qkvm-skze
233) Name: /Health/OIE-FAVN-TEST-RESULTS-BY-MICROCHIP-under-construct  ID: fhan-ym2j
234) Name: /Health/Organ-Procurement-facilities  ID: 678g-isej
235) Name: /Health/Outpatient-Physical-therapy-locations  ID: 3gh2-6seg
236) Name: /Health/Public-Health-Nursing-Listing  ID: x8h7-p5cj
237) Name: /Health/Rural-Health-Clinics  ID: map3-5ue5
238) Name: /Health/STD-HIV-Clinic  ID: gbu4-vtbs
239) Name: /Health/Skilled-Nursing-Care-Facilities  ID: 67hh-8zm9
240) Name: /Health/Statewide-Births-Deaths-Marriages-Civil-Unions-201  ID: bhtq-x545
241) Name: /Health/Statewide-Food-Est-List11-2011  ID: 9ekn-r3cm
242) Name: /Health/Table-10-Cumulative-Sanitary-Surveys-of-Drinking-W  ID: x38n-w8un
243) Name: /Health/Table-11-Total-Underground-Injection-Control-UIC-P  ID: deaj-mj5i
244) Name: /Health/Table-12-Wastewater-Treatment-Plant-Operations-Com  ID: at3v-ejzj
245) Name: /Health/Table-13-Wastewater-Recycled  ID: 56dm-4idp
246) Name: /Health/Table-14-Toxic-Release-Inventory-TRI-in-pounds-  ID: jhq5-pd3u
247) Name: /Health/Table-15-Oil-and-Chemical-Releases  ID: yqmp-94ap
248) Name: /Health/Table-16-Solid-Waste-Generated-Per-Person-Pounds-  ID: eex2-n8qt
249) Name: /Health/Table-17-Solid-Waste-Recycled-in-tons-  ID: v48g-wbhi
250) Name: /Health/Table-18-Leaking-Underground-Storage-Tanks  ID: 5xci-hiqu
251) Name: /Health/Table-19-Hazardous-Waste-Generated  ID: h44e-tzy6
252) Name: /Health/Table-2-Ambient-Levels-of-Airborne-Particulates-PM  ID: fn9b-s9c4
253) Name: /Health/Table-5-Ambient-Levels-of-Carbon-Monoxide-CO-in-Ho  ID: 5abm-p3au
254) Name: /Health/Table-6-Number-of-Hawaiian-Coastal-Waters-by-Islan  ID: crh9-d7dx
255) Name: /Health/Table-7-Number-of-Hawaiian-Perennial-Streams-by-Is  ID: wr45-43y4
256) Name: /Health/Table-9-Percentage-of-Population-served-Safe-Drink  ID: h53f-wetv
257) Name: /Health/Table-A1-Actual-and-Forecast-of-Key-Economic-Indic  ID: h4a4-8vsd
258) Name: /Individual-Rights/HSEC-Organizations-Expenditures-2006-2012-  ID: 6uwv-4qkz
259) Name: /Information-and-Communications/1-USA-gov-Short-Links  ID: wzeq-n5pg
260) Name: /Information-and-Communications/Catalog-of-Federal-Domestic-Assistance-CFDA-Old-Ol  ID: mwm2-x6y4
261) Name: /Information-and-Communications/Central-Contractor-Registration-CCR-FOIA-Extract  ID: 3hqn-qzh6
262) Name: /Information-and-Communications/Federal-Advisory-Committee-Act-FACA-Committee-Memb  ID: kxci-9zen
263) Name: /Information-and-Communications/Federal-Advisory-Committee-Act-FACA-Committee-Memb  ID: z8t4-b33c
264) Name: /Information-and-Communications/Federal-Advisory-Committee-Act-FACA-Committee-Memb  ID: 7ji5-mpn9
265) Name: /Information-and-Communications/Federal-Advisory-Committee-Act-FACA-Committee-Memb  ID: uwfv-c5g3
266) Name: /Information-and-Communications/Federal-Advisory-Committee-Act-FACA-Committee-Memb  ID: tvsq-mxeu
267) Name: /Information-and-Communications/Federal-Advisory-Committee-Act-FACA-Committee-Memb  ID: 3wwp-fssc
268) Name: /Information-and-Communications/Federal-Advisory-Committee-Act-FACA-Committee-Memb  ID: e2uu-kmyn
269) Name: /Information-and-Communications/Federal-Advisory-Committee-Act-FACA-Committee-Memb  ID: 9rrm-cghv
270) Name: /Information-and-Communications/Federal-Advisory-Committee-Act-FACA-Committee-Memb  ID: zx26-9ui3
271) Name: /Information-and-Communications/Federal-Advisory-Committee-Act-FACA-Committee-Memb  ID: fext-zxex
272) Name: /Information-and-Communications/Federal-Advisory-Committee-Act-FACA-Committee-Memb  ID: b348-risj
273) Name: /Information-and-Communications/Federal-Advisory-Committee-Act-FACA-Committee-Memb  ID: 3ne8-smp5
274) Name: /National-Security-and-Veterans-Affairs/FARA-Records  ID: a625-5wu7
275) Name: /Other/2012-Instructional-Letters  ID: qpxs-gtjv
276) Name: /Other/Data-gov-Catalog  ID: pyv4-fkgv
277) Name: /Population/2007-2008-County-to-County-Migration-Inflow  ID: ge38-idt8
278) Name: /Population/2007-2008-State-to-State-Migration-Inflow  ID: 26ye-b8m7
279) Name: /Population/Tax-Year-2007-County-Income-Data  ID: wvps-imhx
280) Name: /Public-Safety/Department-of-Defense-Hawaii-Air-National-Guard  ID: c6ab-tnxf
281) Name: /Public-Safety/Department-of-Defense-Hawaii-Army-National-Guard-F  ID: 9ms4-cvz7
282) Name: /Public-Safety/Department-of-Defense-State-Civil-Defense-Emergenc  ID: jety-j7dm
283) Name: /Public-Safety/State-Civil-Defense-Hurricane-Shelters  ID: vae6-r73i
284) Name: /Public-Safety/Table-10-03-ACTIVE-DUTY-PERSONNEL-BY-SERVICE-1953-  ID: 6c7h-e33a
285) Name: /Social-Services/Libraries-Collection-Statistics-2011  ID: acuw-fgkq
286) Name: /Social-Services/Libraries-Computers-Available  ID: tkwq-e4vi
287) Name: /Social-Services/Libraries-Holdings-FY84-FY12  ID: n84k-kyxx
288) Name: /Social-Services/Libraries-Internet-Sessions-By-Year-FY06-FY11  ID: e85y-zk7s
289) Name: /Social-Services/Libraries-State-Of-Hawaii  ID: jx86-2vch
290) Name: /Transportation-Facilities/Alt-Energy-Station-Data  ID: 36sn-6y6i
291) Name: /Transportation-Facilities/DBEDT-Hawaii-Vehicle-Miles-Traveled-1990-2010  ID: 894w-927z
292) Name: /Transportation-Facilities/Public-Charging-Stations-in-Hawaii  ID: 95x5-qrxh
293) Name: /Transportation-Facilities/Table-18-25-PUBLIC-TRANSIT-FOR-OAHU-1993-TO-2011  ID: 88uj-hez9
294) Name: /dataset/2-1d-VSAT-Recommend-Molokai-By-MMA  ID: htqt-4ghe
295) Name: /dataset/2007-Instructional-Letters  ID: uj9h-52f4
296) Name: /dataset/2008-Election-Administration-and-Voting-Survey-Com  ID: 66b6-term
297) Name: /dataset/2008-Election-Administration-and-Voting-Survey-Com  ID: rk83-5bqj
298) Name: /dataset/2008-Election-Administration-and-Voting-Survey-Com  ID: 7jjx-d6en
299) Name: /dataset/2008-Election-Administration-and-Voting-Survey-Com  ID: p332-7rv5
300) Name: /dataset/2008-Election-Administration-and-Voting-Survey-Com  ID: xm3x-qbi7
301) Name: /dataset/2008-Election-Administration-and-Voting-Survey-Com  ID: 6mia-nc6j
302) Name: /dataset/2008-Uniformed-and-Overseas-Citizens-Absentee-Voti  ID: 2tan-w4es
303) Name: /dataset/2009-Instructional-Letters  ID: pj69-ay3t
304) Name: /dataset/2011-2012-LOBBYIST-and-ORGANIZATIONS  ID: n6vu-fqwd
305) Name: /dataset/2013-2014-LOBBYIST-and-ORGANIZATIONS  ID: wh8j-hrn4
306) Name: /dataset/Blog-Posts  ID: 53b5-749p
307) Name: /dataset/Category-Information  ID: yv27-ghxi
308) Name: /dataset/Category-Stories  ID: p46r-d2ir
309) Name: /dataset/DBEDT-Average-Monthly-Regular-Gasoline-Prices-Hawa  ID: f55i-85xa
310) Name: /dataset/DBEDT-Hawaii-Annual-Electricity-Cost  ID: i7am-7q95
311) Name: /dataset/DBEDT-Hawaii-Electricity-Consumption  ID: qqqb-dua6
312) Name: /dataset/DBEDT-Hawaii-Electricity-Consumption  ID: ya75-e6j8
313) Name: /dataset/DBEDT-Hawaii-Renewable-Energy-Generation-By-Resour  ID: ezj8-myxp
314) Name: /dataset/DBEDT-Hawaii-State-Agencies-Electricity-Consumptio  ID: xpcc-ct2d
315) Name: /dataset/DBEDT-New-Distributed-Renewable-Energy-Systems-Ins  ID: y7ur-vi2p
316) Name: /dataset/DBEDT-Solar-Related-Construction-Expenditures-As-A  ID: 7cps-5y5m
317) Name: /dataset/Distinct-agency-names-in-geospatial-metadata  ID: 6mq7-82cd
318) Name: /dataset/Excess-Federal-Properties  ID: fwrd-p9ax
319) Name: /dataset/First-In-Nation-Energy-Savings-Performance-Contrac  ID: my42-pfm5
320) Name: /dataset/Food-Plate-Data  ID: eqdb-rmqt
321) Name: /dataset/Green-Jobs-By-Industry  ID: grte-hrwt
322) Name: /dataset/Hawaii-Annual-Electricity-Consumption  ID: biet-37vh
323) Name: /dataset/Hawaii-Public-Schools  ID: 6r5m-ppsj
324) Name: /dataset/Hawaii-Training-Providers-2011  ID: 365y-wu3m
325) Name: /dataset/Initial-Conferences-Held-RSN-39973-  ID: yrmn-32dg
326) Name: /dataset/Motions-Hearings-Held-RSN-39976-  ID: c5n8-8cmk
327) Name: /dataset/Number-of-Appeals-RSN-39972-  ID: 6yqr-w4bm
328) Name: /dataset/OIP-Master-UIPA-Records-Request-Semiannual-Log-For  ID: mt2n-teu8
329) Name: /dataset/Report-Card-1-Overall-Hawaii-Visitor-Numbers  ID: puxz-9rab
330) Name: /dataset/Report-Card-2-1a-VSAT-Recommend-Statewide-By-MMA  ID: 787x-dmw4
331) Name: /dataset/Report-Card-2-1b-VSAT-Recommend-Oahu-By-MMA  ID: ajhw-3huu
332) Name: /dataset/Report-Card-2-1c-VSAT-Recommend-Maui-By-MMA  ID: 2g7t-6bmg
333) Name: /dataset/Report-Card-2-1e-VSAT-Recommend-Lanai-By-MMA  ID: uu3p-zrur
334) Name: /dataset/Report-Card-2-1f-VSAT-Recommend-Kauai-By-MMA  ID: 525d-apk2
335) Name: /dataset/Report-Card-2-1g-VSAT-Recommend-Big-Island-By-MMA  ID: 8v3f-iwvf
336) Name: /dataset/Report-Card-2-2a-VSAT-Return-Statewide-By-MMA  ID: cwzq-rpan
337) Name: /dataset/Report-Card-2-3a-VSAT-Expectations-Statewide-By-MM  ID: 7n2q-gb7g
338) Name: /dataset/Report-Card-2b-VSAT-Overall-Satisfaction-Oahu-By-M  ID: j7f6-dpfq
339) Name: /dataset/Report-Card-2c-VSAT-Overall-Satisfaction-Maui-By-M  ID: 7rff-hkaj
340) Name: /dataset/Report-Card-2d-VSAT-Overall-Satisfaction-Molokai-B  ID: 3exa-uvbq
341) Name: /dataset/Report-Card-2e-VSAT-Overall-Satisfaction-Lanai-By-  ID: wyyg-zvvt
342) Name: /dataset/Report-Card-2f-VSAT-Overall-Satisfaction-Kauai-By-  ID: mvkv-3dke
343) Name: /dataset/Report-Card-2g-VSAT-Overall-Satisfaction-Hawaii-Is  ID: qqa6-5vvy
344) Name: /dataset/Report-Card-3a-Resident-Sentiment-Benefits  ID: i58n-7utq
345) Name: /dataset/Report-Card-3b-Resident-Sentiment-Tourism-for-Fami  ID: 3nqr-pbqh
346) Name: /dataset/Report-Card-3c-Resident-Sentiment-Island-Economy  ID: xrap-ydyp
347) Name: /dataset/Report-Card-3d-Resident-Sentiment-Island-Expense-L  ID: jxj3-wzqf
348) Name: /dataset/Report-Card-3e-Resident-Sentiment-Quality-of-Life  ID: asy7-es7y
349) Name: /dataset/Report-Card-3f-Resident-Sentiment-Govt-Promote  ID: mjna-b9qt
350) Name: /dataset/Report-Card-3g-Resident-Sentiment-Jobs  ID: 3nah-v3qi
351) Name: /dataset/Report-Card-3h-Resident-Sentiment-Treatment  ID: sudc-h239
352) Name: /dataset/Report-Card-3i-Resident-Sentiment-Resources  ID: 69kz-wks8
353) Name: /dataset/Report-Card-4a-Tax-Visitor-Expenditures  ID: jaz3-xs6b
354) Name: /dataset/Report-Card-4b-Tax-Tax-Revenues-From-Visitor-Expen  ID: nit8-gtva
355) Name: /dataset/Report-Card-4c-Tax-TAT  ID: qs2i-nbst
356) Name: /dataset/Salmon-Pounds-Per-Year  ID: nw2a-g9kg
357) Name: /dataset/Sample-OIP-Master-UIPA-Records-Request-Log-For-All  ID: emfc-dtj9
358) Name: /dataset/Settlement-And-Status-Conferences-Held-RSN-39974-  ID: kqr4-b9tu
359) Name: /dataset/Slideshow-Content  ID: 7dae-bjqc
360) Name: /dataset/Tax-Returns-Processed  ID: xwuk-s2i8
361) Name: /dataset/Templates  ID: e4x6-f98b
362) Name: /dataset/Templates  ID: g3e5-sdtk
363) Name: /dataset/Third-In-Nation-Clean-Economy-Job-Growth  ID: qb5w-vky4
364) Name: /dataset/Third-In-The-Nation-Cumulative-Installed-Photovolt  ID: bkbb-h3r6
365) Name: /dataset/University-of-Hawaii-Degrees-Awarded-by-Major-Gend  ID: 2xs8-cmdv
366) Name: /dataset/University-of-Hawaii-Enrollment-Demographics  ID: iyed-y2yx
367) Name: /dataset/University-of-Hawaii-Enrollment-by-Zipcode  ID: mj96-8utp
368) Name: /dataset/White-House-Visitor-Records-Requests  ID: 644b-gaut
 => nil
````


# LICENSE

I'm using the [MIT License](http://opensource.org/licenses/MIT "MIT License text") for now, let me know if you have other preferences.  Or, send a pull request.

Copyright (c) 2013 Pas de Chocolat, LLC

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.