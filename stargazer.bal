import ballerina/http;
import ballerina/regex;

http:Client gitClientEndpoint = check new ("https://api.github.com");

# Return the array of github user ids who have starred the repository.
#
# + repository - Github repository URL
# + return - Json array of github users who have starred the repository
public function getGithubUserIds(string repository) returns json[] {
    json[] starredUserIds = [];
    string repositorySubName = getRepositorySubName(repository);

    boolean allStarredUserIdsSaved = false;
    int pageNumber = 1;

    while (!allStarredUserIdsSaved) {
        int recordCountOfPage = 0;
        var response = gitClientEndpoint->get("/repos/" + repositorySubName + "/stargazers?page=" + pageNumber.
        toBalString() + "&per_page=100");

        if response is http:Response {
            var jsonResponse = response.getJsonPayload();
            if jsonResponse is json {
                if jsonResponse is json[] {
                    recordCountOfPage = jsonResponse.length();
                    foreach var i in 1 ..< recordCountOfPage {
                        var element = jsonResponse[i - 1];
                        if element is map<json> {
                            starredUserIds[(pageNumber - 1) * 100 + i - 1] = element["login"];
                        }
                    }
                }
            }
        }
        if (recordCountOfPage < 100) {
            allStarredUserIdsSaved = true;
        }
        pageNumber += 1;
    }
    return starredUserIds;
}

# Returns the sub name of the repository (eg: ballerina-platform/ballerina-lang).
# ```ballerina
# log:printDebug("debug message", id = 845315)
# ```
# + repositoryUrl - URL of repository
# + return - full name of the repository
function getRepositorySubName(string repositoryUrl) returns string {
    string[] repoArray = regex:split(repositoryUrl, "/");
    string substring = repoArray[3] + "/" + repoArray[4];
    return substring;
}
