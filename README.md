
    1. How does your script work? (if not addressed in comments in source)
        Basically all of the code is commented. But the general idea is that I've separated each specific requirement 
        into its own method (retrieve XML, convert to JSON, update product). I've added a helper method because on the
        conversion from XML to JSON some keys end up with a '@' or '_' which needs to be removed. There might be a 
        different way of converting from XML to JSON or a different library that doesn't add the '@', but I'm not 
        aware of any.
        In order to run the script from the command line, in Windows the command line needs to be on the location of 
        the script and run the following command:
        ruby exercise.rb <FTP-HOST> <FTP-USERNAME> <FTP-PASSWORD> <API-URL> <API-KEY>
        where each variable is replaced with the expected value.

    2. What documentation, websites, etc did you consult in doing this assignment?
        Since I don't have any experience in Ruby development, I've used several sources, including the official Ruby
        documentation, online tutorials and Stack Overflow.

    3. What third-party libraries or other tools does the script use? How did you choose each library you used?
        -net/ftp - to connect to the FTP server
        -net/http - to call the API
        -json - to parse the JSON products
        -nokogiri - to parse the XML products  
        -nori - to convert from XML to JSON
        -uri - to create each URL to call the API

    4. How long did you spend on this exercise? If you had unlimited additional time to spend on this, how would you 
    spend it and how would you prioritize each item?
        As I don't have any experience with Ruby, I've spent a couple of hours studying how to develop in Ruby and then
        some 4 hours developing the actual script, structuring the code, adding comments and writing the READMEN. 
        The barebones of the script was relatively fast to develop, but things like error handling, the separation in 
        different methods, receiving the variables as input and all error messages took some time add, as I had to 
        search online how those work in Ruby.
        In that development time I'm also considering any time I used for testing, where I created some postman requests
        to update and retrieve each product, so that I could guarantee that my updates were successfull.

        If I had infinite time, I would make some changes to my code, such as adding some unitary tests to my code,
        change the way the variables are being received to receive them from a text file instead of having to type each
        one of them. I would search for some other libraries that maybe had the ability of parsing the XML, converting 
        to JSON and parsing the JSON all in one, instead of having to use different libraries. Another option would be
        to add a flag, like a debug flag, that when active, would print more information about what the code is doing, 
        maybe even printing the actual products list, ftp connection details, the info being sent to the API, etc.
        Also I would improve the error handling, because right now it's simply catching the most generic error and
        returning the message of the error, the code could be changed to better handle some specific cases. Another
        option would be to save locally the retrieved XML file and the transformed JSON list of products.

    5. If you were to critique your code, what would you have to say about it?
        As I mentioned on the previous point, some things like the error handling is extremely basic, the code also
        has a lot of typed text, if the script was larger and there was a need to repeat several names or messages,
        I would prefer to define as variables those names and messages and then use the variables instead of typing the
        same text over and over. There might also be some problems regarding the way variables or methods are named, as
        I don't know what the naming convention is in Ruby, I've used what I'm most familiar with, which might not be
        the most correct option. I also haven't done any perfomance testing for my code, but just by looking at it I can
        tell that the code could be faster if I wasn't doing the name cleanup, as I'm iterating over all of the keys of 
        each product and removing the '@' and '_' so that the names match with the names from the API, there might be
        some library that allows me to do that cleanup right as I'm parsing or converting the file. Since the test is
        relatively small, performance won't likely be impacted, but if we were talking about millions of files with tens
        or hundreds of fields each, it could lead to performance loss.
