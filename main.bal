import ballerina/io;

public function main() {
    string repository = "https://github.com/ballerina-platform/ballerina-lang";
    string outFile = "stargazers.json";

    json users = getGithubUserIds(repository);
    var result = io:fileWriteJson(outFile, users);
}
