# Soccer rank problem

## Usage
### Running the script
This script can take input from arguments or stdin, see below examples.
1. Examples:
```bash
# via arguments
$mix soccer_rank -f sample-input.txt -o output.txt -t txt
# via stdin
$cat sample-input.txt | mix soccer_rank -o output.html -t html
```

2. Arguments:
```
-f FILE         Path to the input file
-o FILE         Path to the output file
-t FORMAT       Output file format (html/txt)
```
## Running the tests
To run the tests, use the following command:
```bash
$mix test
```
## The problem
- [Gist](https://gist.github.com/linhchauatx/e8f36f8fbdc95b957d7b86fa10b68b02)