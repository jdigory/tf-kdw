backend default {
    .host = "127.0.0.1";
}

sub vcl_recv {
#FASTLY recv
    error 901;
}

sub vcl_error {
#FASTLY error
    if (obj.status == 901) {
        set obj.status = 200;
        set obj.response = "OK";
        set obj.http.Content-Type = "text/html; charset=utf-8";
        synthetic {"
<!DOCTYPE html>
<html lang="en">
<head>
  <title>kdw</title>
  <style>
    body {
      font-family: Georgia, Times, "Times New Roman", serif;
      text-align: center;
    }
    h1 {
      font-size: 70px;
      font-weight: normal
    }
  </style>
</head>
<body>
  <h1>kilo delta whiskey</h1>
</body>
</html>
"};
        return(deliver);
    }
}
