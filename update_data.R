library(data.table)
library(jsonlite)
library(httr)
library(stringr)
library(naturalsort)
library(circhelp)

headers = c(
  `Authorization` = sprintf("Bearer %s", Sys.getenv("JATOS_TOKEN"))
)

jatos_url <- 'https://jatos.mindprobe.eu/jatos/api/v1/'
res <- httr::GET(url = paste0(jatos_url, "admin/token"), httr::add_headers(.headers=headers))

randstring <- function(n = 5000) {
  a <- do.call(paste0, replicate(5, sample(LETTERS, n, TRUE), FALSE))
  paste0(a, sprintf("%04d", sample(9999, n, TRUE)), sample(LETTERS, n, TRUE))
}
data_list <- list()
study_uid_list <- c('932ce091-60a9-4787-a4a9-a3cc1a0f75b8')
for (study_uid in study_uid_list){
  temp_dir <- tempdir(check = T)
  temp_dir <- gsub('\\\\', '/', temp_dir)
  temp_dir <- gsub('C:/Users/ANCHE7~1/','c:/temp/', temp_dir)
  temp_dir <- paste(temp_dir, randstring(1), sep = '/')
  res_file <- paste0(tempfile(),'.zip')
  # h <- new_handle()
  # handle_setheaders(h, headers)
  url <-  sprintf("%sresults?studyUuid=%s", jatos_url, study_uid)
  # curl_download(url, res_file, quiet = F, handle = h)
  # rawToChar(curl_fetch_memory(url, handle = h)$content)
  system(sprintf('curl -i -H "Authorization: %s" %s --output "%s"', headers[['Authorization']], url, res_file))
  # results <- GET(url = url, httr::add_headers(.headers=headers), write_disk(res_file))
  unzip(res_file, exdir=temp_dir)  # unzip your file
  # 
  metadata <- jsonlite::fromJSON(list.files(temp_dir, '*.json', full.names = T, recursive = T))$data$studyResults[[1]]
  
  finished_study_ids <- metadata[,c('id', "endDate", "startDate")]
  setDT(finished_study_ids)
  finished_study_ids[,id:=as.character(id)]
  finished_study_ids[,endDate:=as.POSIXct(endDate/1000, origin="1970-01-01")]
  finished_study_ids[,startDate:=as.POSIXct(startDate/1000, origin="1970-01-01")]
  
  comp_res_meta <- rbindlist(lapply(1:length(metadata$componentResults), \(x) {
    dt <- as.data.table(metadata$componentResults[[x]])
    dt$user_pid <- metadata$urlQueryParameters$USER_ID[[x]]
    dt
  }), fill = T)
  flist <- list.files(temp_dir, '*.txt', full.names = T, recursive = T)
  # flist <- flist[str_extract(flist,'study_result_(\\d+)', group = 1)%in%finished_study_ids$id]
  
  cur_data <- suppressWarnings(rbindlist(lapply(c(flist), \(x){
    print(x)
    comp_res_id <- str_extract(x, '(?<=comp-result_)\\d{6}')
    data <- read_json(x)
    if (length(data)<10){
      return(data.frame())
    }
    browser_check <- data.frame(data[[1]])
    setDT(browser_check)
    
    data <- data[sapply(data, \(x) x$trial_type=='psychophysics')]
    data <- rbindlist(data, fill = T)
    if (!('score' %in% colnames(data))){
      return(data.frame())
    }
    if (!('user_pid' %in% names(browser_check))|!('user_pid' %in% names(data))){
      browser_check$user_pid <- comp_res_meta[id==comp_res_id, user_pid]
      data$user_pid <- comp_res_meta[id==comp_res_id, user_pid]
    }
    
    
    data[!is.na(target_colors), target_real_sd:=circ_sd_360(as.numeric(str_split(target_colors,',', simplify = T))), by = target_colors]
    data[!is.na(distr_colors), distr_real_sd:=circ_sd_360(as.numeric(str_split(distr_colors,',', simplify = T))), by = distr_colors]
    setnafill(data, type = "locf",cols = c('trial_number','target_color','distr_color','target_sd', 'distr_sd','target_real_sd', 'distr_real_sd','target_pos_angle','distr_pos_angle', 'target_x', 'distr_x', 'feat_sim_bin', 'spat_sim_bin', 'color_bin'))
    data[,score:=as.numeric(score)]
    setnafill(data, type = "nocb",cols = c('score'))
    data[,target_color:=angle_diff_360(target_color,0)]
    data[,distr_color:=angle_diff_360(distr_color,0)]
    data[,resp_pos:=angle_diff_360(resp_pos,0)]
    data[,resp_color:=angle_diff_360(resp_color,0)]
    
    
    #
    if (browser_check[1, .(trial_type)]=='browser-check'){
      data<-merge(data, browser_check[,.(width, height, fullscreen, user_pid)], by = c('user_pid'))
    }
    data <-data[trial_type=='psychophysics'&grepl('resp',seq_type)]
    # data[, error:=angle_diff_360(resp_color, target_color)]
    data[,subject_id:=str_extract(x, 'study_result_(\\d+)', group = 1)]
    data[,result_id:=str_extract(x, 'comp-result_(\\d+)', group = 1)]
    data <- merge(data, finished_study_ids, by.x = 'subject_id', by.y = 'id')
    
    data
    
  }), fill = T))
  
  data_list <- append(data_list, list(cur_data))
}

data <- rbindlist(data_list)
data <- drop.empty.cols(data)
data <- data[block>0&user_pid!='999999',.SD,.SDcols = !c('response_type','trial_type')]
data[user_pid=='319362'&startDate=='2024-09-23 17:08:03', user_session_id:= 1]
data[,.N, keyby = .(endDate,user_pid,subject_id,  user_session_id)][,.N, by = user_session_id]
data[,table(user_pid,  user_session_id)]

data[,sub_sess:=naturalsort::naturalfactor(interaction(user_pid, user_session_id, sep='.S'))]
saveRDS(data, 'color_in_space_data.rds')