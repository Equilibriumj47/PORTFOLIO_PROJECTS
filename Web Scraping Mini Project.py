from bs4 import BeautifulSoup
import requests
import time
print('Kindly input unfamiliar skills: ')
unfamiliar_skills = input('>')
print(f'Filterling out {unfamiliar_skills}')
def find_jobs():
    html_text = requests.get('https://www.timesjobs.com/candidate/job-search.html?searchType=personalizedSearch&from=submit&searchTextSrc=&searchTextText=&txtKeywords=data+analyst&txtLocation=').text
    soup = BeautifulSoup(html_text, 'lxml')
    jobs = soup.find_all('li', class_= 'clearfix job-bx wht-shd-bx')
    for index, job in enumerate(jobs):

        published_date = job.find('span', class_ = 'sim-posted').span.text

        if 'Posted few days ago' in published_date:
            print(published_date)
            company_name = job.find('h3', class_ = 'joblist-comp-name').text
            skills = job.find('span', class_ = 'srp-skills').text
            skills_2 = skills.replace(' , ',', ')
            more_info = job.header.h2.a['href']
            if unfamiliar_skills not in skills:
                with open(f'wsp_jobs/{index}.txt', 'w') as f:
                    f.write(f'Company Name: {company_name.strip()}\n')
                    f.write(f'Required Skills: {skills_2.strip()}\n')
                    f.write(f'More Info: {more_info}')
                print(f'file saved in: {index}')
                
if __name__ == '__main__':
    while True:
        find_jobs()
        time_wait = 10
        print(f'Waiting {time_wait} minutes...')
          
        time.sleep(time_wait * 60)