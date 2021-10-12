# locale options: en_US, de_DE, ru_RU and fi_FI
# outdir = directory name

download_data  <- function(locale, outdir) {
    data_path <- here("data")
    
    if (dir.exists(here(data_path, outdir))) {
        print("directory already exists")
    } else {
        options(timeout = 200) # to prevent timeout error
        
        # download data into temp file
        temp <- tempfile()
        download.file(url = "https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip",
                      temp)
        
        # unzip tempfile and remove
        unzip(zipfile = temp, exdir = data_path)
        unlink(temp)
    }
    
    # save directory of extracted zip file
    final_path <- here(data_path, "final")
    
    # create outdir directory
    dir.create(here(data_path, outdir))
    
    # grabs files with en_US
    old_names <-
        list.files(
            path = final_path,
            pattern = paste0("^", locale),
            recursive = TRUE
        )
    
    # provide new names
    new_names <- c("blogs.txt", "news.txt", "twitter.txt")
    
    # rename and remove old ones.
    file.rename(from = file.path(final_path, old_names),
                to = file.path(here(data_path, outdir), new_names))
    
    # remove final folder from zip file
    unlink(here(data_path, "final"), recursive = TRUE)
}