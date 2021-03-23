import ballerina/io;

public function main() {
    string[] users = getRepositoryStarredUseIds("https://github.com/ballerina-platform/ballerina-lang");
    io:println("Users: ", users);
}
