GetPredictions <- function(executor_number, total_executors){  
  df = data.frame(matrix(vector(), 0, 6,dimnames=list(c(), c("link_id", "direction","exec","step","dt","Predicted"))),stringsAsFactors=F)				
  #get traindata
  print("Getting OSM links...")
  OSM_Links <- data.table::fread("data/OSM_Main_Links.csv")
  OSM_Links <- as.data.frame(OSM_Links[,])
  print("OK. The number of links is:")
  print(nrow(OSM_Links))
  
  print("Getting latest train dataset...")
  Data<-try(as.data.frame(read.table("http://160.40.63.115:23577/fcd/traindata.csv?offset=0&limit=-1", header = TRUE, sep = ";"),silent = TRUE))
  print("OK. The number of rows in this dataset was:")
  print(nrow(Data))
  
  #set next dt target
  next_dt <- as.POSIXct(Data[which.max(as.POSIXct(Data$Date)),3]) + 900
  print("Calculating predictions for:")
  print(next_dt)
  
  #insert the same execution timestamp for all links
  exec_tstamp <-Sys.time();
  
  #for all the links, produce a prediction
  i <- 0;  
  print("This executor will handle links from:")
  from_number <- (((nrow(OSM_Links)/total_executors)*(executor_number - 1)) + 1)
  print("To:")
  to_number <- (((nrow(OSM_Links)/total_executors)*(executor_number - 1)) + (nrow(OSM_Links)/total_executors))  
  
  for (i in from_number:to_number){ 
    print("Iteration:")
    print(i)
    pred <- try(kStepsForward(Data = Data, Link_id = OSM_Links[i,1], direction = OSM_Links[i,2], datetime = next_dt, predict = "Mean_speed", steps = 1),silent=FALSE) 
    print("Prediction:")
    print(pred)	 
    if (class(pred) == "try-warning" || class(pred) == "try-error") {		
      #smth went wrong, continue
    }
    else{
      #We got some results. Set exec_timestamp for all predictions produced in the current run
      #Comment the following line to include the actual exec_timestamp for each link in the returned dataset
      pred[,3] = as.character(exec_tstamp)
      df <- rbind(df,pred)	 
    }	
    i <- i+1;
  }
  return(df)
}
