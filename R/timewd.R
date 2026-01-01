#' @noRd
as_character_time <- function(timen){
  
  # Convert seconds to "h:mm:ss" (hours can be >= 24)
  h = timen %/% 3600
  m = (timen %% 3600) %/% 60
  s = as.integer(timen %% 60)
  
  ret = sprintf("%01d:%02d:%02d", h, m, s)
  
  return(ret)
}

#' @noRd
noround_digit <- function(decimal){
  
  # Find the smallest digit x such that rounding decimal to x digits is NOT 1
  # (used to detect whether fractional seconds rounding will carry to next second)
  
  d_length = nchar(decimal) - 2
  
  for (x in seq_len(d_length)) {
  
    if ( roundup(decimal, x) != 1) {
      return(x)
    }else{
      ret = d_length
    }
  }

  return(ret)
}

 
# sas_round <- function(x, d = 0) {
#   
#   ret = sign(x) * floor(abs(x) * 10**(d) + 0.5) / 10**(d)
#   
#   return(ret)
# }

#' @noRd
format_timewd <- function(x, w, d = 0){
  options(digits.secs = 6)

  vectorize<-function(x1){
    
  if (is.na(x1)) {
    return(NA_character_)
  }
  # ---- Validate TIMEw.d parameters ----
  if (!w %in% 2:20) {
    
    stop(paste0("'TIMEw.d' width must be between 2 and 20."))
  }
  if (!d %in% 0:19) {
    
    stop(paste0("'TIMEw.d' number of digits must be between 0 and 19."))
  }
  if (w <= d){
    stop(paste0("'TIMEw.d' number of digits must be less than the width"))
  }
 
  # ---- Normalize input to seconds (timen) + sign ----
  if ("POSIXt" %in% class(x1)){
    
    timen <- as.integer(format(x1, "%H")) * 3600 +
      as.integer(format(x1, "%M")) * 60 +
      as.numeric(format(x1, "%OS"))
    
    sign = ""
  }
  
  if ("hms" %in% class(x1)){
      
      if (is.na(x1)) return(NA_character_)
    
      if (as.numeric(x1) < 0){
        
        timen = abs(as.numeric(x1))
        sign = "-"
        
      }else{
        
        timen = as.numeric(x1)
        sign = ""
      }
      
    }  
    
  if ("numeric" %in% class(x1)){
    if (is.na(x1)) return(NA_character_)
    
    if (x1 < 0){       
      
      timen = abs(x1)
      sign = "-"
    }else{
      
      timen = x1
      sign = ""
    }
  }
   
  # ---- If d=0, round to nearest second first ----  
  if (d == 0){
    timen = roundup(timen)
  }
  
  # ---- Split into integer clock part + fractional part ----
  hms = as_character_time(timen)
  int_w_length = nchar(hms) + as.numeric(sign == "-")
  #decimal = ifelse(timen %% 1 == 0, 0, as.numeric(sub("^[^.]*", "", timen)))
  decimal = timen %% 1
  # Maximum decimals that can fit: leave 1 char for dot  
  max_d_length = w - int_w_length - 1
  real_d_length = if (d < max_d_length) d else max_d_length
  
  
  # ---- Handle fractional seconds formatting / rounding ----
  if (decimal != 0 & max_d_length > 0) { 

    # If decimal rounds to 1 at low digits, rounding causes carry to next second    
    noround = noround_digit(decimal)
    
    if (real_d_length < noround){
      # Carry into the next second and recompute available decimal width      
      hms = as_character_time(timen + 1)
      
      int_w_length = nchar(hms) + as.numeric(sign == "-")
      max_d_length = w - int_w_length - 1
      real_d_length = if (d < max_d_length) d else max_d_length
      
      # Force decimal part to 0.00... after carry
      decimal_f = paste0("0.", strrep("0", real_d_length))
    }else{
      # Round fractional seconds to real_d_length digits and pad trailing zeros if needed
      # This is for decimals like .005 or .10005
      decimal_r1 = roundup(decimal, digits = real_d_length)
      #decimal_r1 = sas_round(decimal, d = real_d_length)
      decimal_r = ifelse(decimal_r1 ==0, "0.", decimal_r1)
      d_round = nchar(decimal_r) - 2
      
      decimal_f = if (d_round < real_d_length){
         paste0(decimal_r, strrep("0", real_d_length - d_round) )
      }else{
         decimal_r
      }
      

    }
    
  }else if (d != 0 & max_d_length > 0){
    # No fractional part but d>0 => print .00... as long as it fits
    max_d_length = w - int_w_length - 1
    real_d_length = if (d < max_d_length) d else max_d_length
    decimal_f = paste0("0.", strrep("0", real_d_length))
    
  }else if (max_d_length <= 0){
    # Not enough room for decimals (or even full h:mm:ss); re-round and re-evaluate
    timen = roundup(timen)
    hms = as_character_time(timen)
    int_w_length = nchar(hms) + as.numeric(sign == "-")
  }


  # ---- Apply sign to clock string ----
  hms = paste0(sign, hms)
  #int_w_length = int_w_length + as.numeric(sign == "-")
  # Hours-field width (chars before first colon)
  hw = regexpr(":", hms) - 1 
  
  # ---- Width-based truncation rules (SAS-like) ----
  if (w < hw){
    # Can't even fit the hour field => "**"
    ret = "**"
    return(ret)
    
  }else if (hw <= w & w < hw + 3){
    # Only hours fit
    hh = substr(hms, 1, hw)
    ret = paste0(strrep(" ", w - hw), hh)
    
  }else if (hw + 3 <= w & w < hw + 6){
    # Hours + ":mm" fit
    hhmm = substr(hms, 1, hw+3)
    ret = paste0(strrep(" ", w - (hw + 3)), hhmm)
    
  }else if (hw + 6 <= w & w < hw + 8){
    # Hours + ":mm:ss" fit (no decimals)
    hhmmss = hms
    ret = paste0(strrep(" ", w - (int_w_length)), hms)
    
  }
  
  if (w < hw + 8){
    # If not enough for full "h:mm:ss", return truncated result
    return(ret)
    
  }else if (w >= hw + 8){
    # Full "h:mm:ss" fits
    hms_f = hms
    
    if (d == 0){
      # No decimals: pad left to width and return
      ret = paste0(strrep(" ", w - int_w_length), hms)
      return(ret)
    }
    
  }
  
  
  # ---- Combine h:mm:ss with decimal part ----
  decimal_f_c = substring(as.character(decimal_f), first = 2)
  combine = paste0(hms_f, decimal_f_c)
  
  # Ensure exactly real_d_length decimal digits (pad trailing zeros if needed)
  if (nchar(decimal_f_c) - 1 < real_d_length){
    pad0 = real_d_length - (nchar(decimal_f_c) - 1)
    final_pad = paste0(combine, strrep("0", pad0))
  }else{
    final_pad = combine
  }
  
  # ---- Left-pad with spaces to width ----
    
    if (nchar(final_pad) < w){
      
      leadspc = w - nchar(final_pad)
      ret = paste0(strrep(" ", leadspc), final_pad)
      
    }else{
      ret = final_pad
    }
  
  return(ret)
  }
  # Vectorized wrapper
  vapply(x, vectorize, FUN.VALUE = character(1))
}
