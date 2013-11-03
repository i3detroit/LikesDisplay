import com.francisli.processing.http.*;



// instantiate a (global) new HashMap
HashMap params = new HashMap();
//create font for displaying
PFont f;
//create HTTP client for accessing facebook
com.francisli.processing.http.HttpClient client;

int lastFBUpdate;
int FB_UPDATE_PERIOD = 10000;  //update period in milliseconds
int ANIMATION_TIME_CONST = 3000; //how fast the fly-in animation goes (a smaller number is faster)
int lastFBLikes = 0;
int endTextSize = 200;
int timeOfLastFBChange = 0;
int likes = 0;
int scaleFactor;
int tmp;
int txtSize;

void setup() {
  // create new client
  client = new com.francisli.processing.http.HttpClient(this, "graph.facebook.com");

  // pass parameters as key-value pairs
  params.put("fields", "likes");

  //Setup all the font crap
  size(640, 360);
  // Create the font
  println(PFont.list());
  f = createFont("Arial", 36);
  textFont(f);
  
  //slow down animation
  frameRate(30);

  //kick off the first request
  client.GET("i3detroit", params);
  lastFBUpdate = millis();
}

void responseReceived(com.francisli.processing.http.HttpRequest request, com.francisli.processing.http.HttpResponse response) {
  // check for HTTP 200 success code
  if (response.statusCode == 200) {
    com.francisli.processing.http.JSONObject results = response.getContentAsJSONObject();

    // get the likes element in the array and return as a String
    likes = results.get("likes").intValue();

    // print out the name
    println("likes = " + likes);
  } 
  else {
    // output the entire response as a string
    println(response.getContentAsString());
  }
}


void draw() {
  // Call a FB update refresh if 10 seconds have passed
  if (millis() > (lastFBUpdate + FB_UPDATE_PERIOD)) {
    // make the request to the i3detroit page every 10 seconds

    client.GET("i3detroit", params);
    lastFBUpdate = millis();
  }

  //do all the fun drawing and animation
  if (likes != lastFBLikes) {
    //update current number of likes
    println("New likes number: " + likes);
    println("Old one was: " + lastFBLikes);
    lastFBLikes = likes;
    timeOfLastFBChange = millis();
 
  }


  //paint the background
  background(255);
  // write text
  textAlign(CENTER);
  fill(24, 135, 191);
  textSize(36);
  text("i3Detroit Facebook Likes Counter:", width/2, 80);
  //calculate how big to make this text based on the last FB Likes number change
  if ((timeOfLastFBChange + ANIMATION_TIME_CONST) < millis()) {
    textSize(endTextSize);
  } 
  else {
    tmp = timeOfLastFBChange + ANIMATION_TIME_CONST - millis();
    txtSize = 36;
    scaleFactor = tmp;
    if (tmp < 0) {
      tmp = 0;
    }
    println("Temp: " + tmp);
    println("Scale Factor: " + scaleFactor);
    txtSize = endTextSize + (400*(scaleFactor))/ANIMATION_TIME_CONST;
    println("TextSize: " + txtSize);
    textSize(txtSize);
  }

  text(likes, width/2, 290);
}

