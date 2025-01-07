from jira import JIRA
import os

jiraOptions = {'server': "https://amalgamrx.atlassian.net", "headers": {"Accept": "application/json"}}
jira = JIRA(options=jiraOptions, basic_auth=("bks@amalgamrx.com", os.environ["JIRA_PAT"]))


def printErrorMsg():
    print('''
  Please provide a valid Release version name as per JIRA
  the format should be in the following pattern 
  <JIRA issue>  <release-version-name> 
  MAKE SURE RELEASE-VERSION-NAME SHOULD NOT CONTAIN ANY SPACES
      
  eg: SPAN-1234 iSage2.0.0
  ''')

try:
  detailsForReleaseCheck = "AVHN-302 RegeneronV1.0".split()
  issue_id = detailsForReleaseCheck[0]
  release_name = detailsForReleaseCheck[1]
  print("*********************")
  print(issue_id)
  print(release_name)
  print("*********************")

  try:
    singleIssue = jira.issue(issue_id)
    project_key = singleIssue.fields.project.key
    print('JIRA Project_key: ' + project_key)
    print('JIRA Release_name: ' + release_name)
    releaseVersionCheck = jira.get_project_version_by_name(project=project_key, version_name=release_name)
    if releaseVersionCheck == None or releaseVersionCheck.released or releaseVersionCheck.archived:
      printErrorMsg()
      exit(1)
  except:
    print("No Valid JIRA ticket found")
    exit(1)
except(IndexError):
  printErrorMsg()
  exit(1)

count = 0
try:
  query = f'project = "{project_key}" AND fixVersion = "{release_name}"'
  issues = jira.search_issues(query, maxResults = False)
  file_name = "CHANGELOG.md"

  with open(file_name, "w") as file:
    # file.write("<html>\n")
    # file.write("<head><title>ChangeLog</title></head>")
    # file.write("<body>\n")

    for issue in issues:
      count+=1
      jira_link = f"https://amalgamrx.atlassian.net/browse/{issue.key}"
      link = f"[{issue.key}]({jira_link})"
      file.write(f"{link} : {issue.fields.summary}\n")
      # file.write(f"<p>Description: {issue.fields.summary} </p>\n\n")
    print("No of issues: " + str(count))
    file.write(f"Total number of issues found: {str(count)}\n")
    # file.write("</body>\n")
    # file.write("</html>\n")

  print("Changelog created")
except:
  print("unable to create release notes")
  exit(1)
