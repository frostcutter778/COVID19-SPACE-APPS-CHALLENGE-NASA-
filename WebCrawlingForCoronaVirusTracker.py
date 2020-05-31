from bs4 import BeautifulSoup as soup
from urllib.request import urlopen as ureq
import substring
import time

import urllib



while True:

    req = urllib.request.Request(
        url="https://www.worldometers.info/coronavirus/#nav-today",
        data=None,
        headers={
            'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/35.0.1916.47 Safari/537.36'
        }
    )

    html_page = ureq(req).read()

    client = ureq(req)
    html_page = client.read()
    client.close()

    page_soup = soup(html_page, "html.parser")

    container = page_soup.find_all('div', {"class": "main_table_countries_div"})
    container = container[0]

    x = 0
    y=0
    for row in container.findAll("tr"):
        if (x <= 8):
            x = x + 1





        else:
            try:

                cells = row.findAll("td")

                country = cells[0].find(text=True),
                Total_cases = cells[1].find(text=True),
                New_cases = cells[2].find(text=True),
                Total_deaths = cells[3].find(text=True)

                New_deaths = cells[4].find(text=True)
                Total_recovered = cells[5].find(text=True)
                Active_cases = cells[6].find(text=True)
                Serious_critical = cells[7].find(text=True)
                Top_cases = cells[8].find(text=True)
                Total_deaths = str(Total_deaths)
                Total_deaths = Total_deaths.strip()
                if country[0] == "Total:":
                    y=y+1
                    if y>7:
                        data = {
                            'Country': country[0],
                            'Total_cases': Total_cases[0],
                            'New_cases': New_cases[0],
                            'Total_deaths': Total_deaths,
                            'New_deaths': str(New_deaths),
                            'Total_recovered': str(Total_recovered).rstrip(),
                            'Active_cases': str(Active_cases),
                            'Serious_critical': str(Serious_critical),
                            'Top_cases': str(Top_cases)
                        }
                        print(data)


                        
                else:

                    data = {
                        'Country': country[0],
                        'Total_cases': Total_cases[0],
                        'New_cases': New_cases[0],
                        'Total_deaths': Total_deaths,
                        'New_deaths': str(New_deaths),
                        'Total_recovered': str(Total_recovered).rstrip(),
                        'Active_cases': str(Active_cases),
                        'Serious_critical': str(Serious_critical),
                        'Top_cases': str(Top_cases)
                    }
                    print(data)


                    

                    time.sleep(1)
            except:
                pass
    murl = 'https://www.michigan.gov/coronavirus/0,9753,7-406-98163_98173---,00.html'
    client1 = ureq(murl)
    michi_page = client1.read()
    client1.close()

    mpage_soup = soup(michi_page, 'html.parser')

    mcontainer = mpage_soup.find_all('table')
    mdata = mcontainer[0].find_all('tr')

    cell = mdata[-1].findAll('td')
    total = cell[1].text
    # total = substring.substringByChar(str(total), endChar='<', startChar='g')
    # total = total[2:-1]
    print(total)
    death = cell[2]
    death = substring.substringByChar(str(death), endChar='<', startChar='>')
    death = death[1:-1]
    print(cell[2])

    michigandata = {
        'Total_case': total,
        'death': death
    }

    
    req1 = urllib.request.Request(
        url="https://www.worldometers.info/coronavirus/country/us/",
        data=None,
        headers={
            'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/35.0.1916.47 Safari/537.36'
        }
    )

    us_page = ureq(req1).read()

    clientus = ureq(req1)
    us_page = clientus.read()
    clientus.close()

    us_soup = soup(us_page, "html.parser")
    # us_soup=us_soup.find_all('div',{'class':'tab-pane active'})
    uscontainer = us_soup.find('table', {'id': 'usa_table_countries_today'})
    print(len(uscontainer))

    y = 0

    for row in uscontainer.findAll('tr'):
        if y == 0:
            y = y + 1
        else:
            uscells = row.findAll('td')
            state = uscells[0].find(text=True)
            total_case = uscells[1].find(text=True)
            new_case = uscells[2].find(text=True)
            total_death = uscells[3].find(text=True)
            new_death = uscells[4].find(text=True)
            active_case = uscells[5].find(text=True)

            usData = {
                "state": state.strip(),
                'total_case': total_case,
                'new_case': new_case,
                'total_death': total_death.strip(),
                'new_death': new_death,
                'active_case': active_case.strip()
            }
            print(usData)

            

    time.sleep(1800)
    