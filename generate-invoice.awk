#!/usr/bin/env awk -f 

BEGIN {

  FS="\t" ;

  t = 0 ;

  print "\\documentclass{article}" ;

  print "\\parskip=0.1in" ;
  print "\\parindent=0in" ;

  print "\\usepackage{datetime}" ;

  print "\\usepackage{palatino}"; 

  print "\\usepackage{fullpage}" ;

#  print "\\usepackage[letterpaper,landscape,margin=1in]{geometry}" ;


  print "\\begin{document}" ;


}

$1 == "From" {
  from = $2 ;
}

$1 == "To" {
  to = $2 ;

  print "{\\Large \\textbf{Invoice: " from " to " to "}}\\hfill \\today\\\\\n" ;
}


{
  gsub(/&/,"\\\\&") ;
  gsub(/\$/,"\\$",$5) ;
}

$1 == "Name" {
  print "\\textbf{Provider} \\mbox{}~\\hfill{} \\textbf{Recipient} \\\\"
  print $2 "\\mbox{}~\\hfill " $3 " \\\\" ;
}

$1 == "Address" {
  print $2 "\\mbox{}~\\hfill " $3 " \\\\" ;
}

($1 == "Rate") && !seen["Rate"]++ {

  print "" ;

  print "{\\Large\\textbf{Rates}}\n\n" ;

  print "\\begin{tabular}{ll}" ;
}

$1 == "Rate" {
  rate[$2] = $3 ;
  printf "\\textbf{%s} & \\$%'.2f / hour \\\\\n", $2, $3 ;
}

seen["Rate"] && ($1 != "Rate") {
  print "\\end{tabular}" ;
  delete seen["Rate"] ;
}


$1 == "Date" {

  print "" ;

  print "{\\Large\\textbf{Hours}}\n\n" ;

  print "\\begin{tabular}{|l|r|l|r|l|}" ;
  print "\\hline" ;
  print "\\textbf{Date}&\\textbf{Minutes}&\\textbf{Rate}&\\textbf{Amount}&\\textbf{Description} \\\\ \\hline" ;

}


# If there is an hourly rate for this category:
rate[$4] && (from <= $1 && $1 <= to) {
  task=$5 ;
  minutes[$4] += $6
  printf "\\hline\n" $1 " & " $6 " & " $4 " & \\$%'.2f & " task "\\\\\n", ($6/60)*rate[$4] ;
}


# Travel is handled separately:
($4 == "Travel") && (from <= $1 && $1 <= to) {

  gsub(/\$|,/,"",$8) ;

  travel_date[t] = $1 ;
  travel_desc[t] = $5 ;
  travel_amount[t] = $8 ;

  travel_total += travel_amount[t] ;

  ++t ; 
}

END {

  ORS="\n" ;

  print "\\hline" ;

  print "\\end{tabular}\n\n" ;

  for (k in minutes) {
    totals[k] = (minutes[k]/60)*rate[k]  ;
    printf "Sub-total (" k "): \\$%'.2f \\\\", totals[k] ;
    item_total += totals[k] ;
  }

  print "\n\n" ;

  print "{\\Large\\textbf{Travel}}\n\n" ;

  print "\\begin{tabular}{|l|l|l|}" ;
  print "\\hline" ;
  print "\\textbf{Date}&\\textbf{Amount}&\\textbf{Description}\\\\ \\hline" ;

  for (i = 0; i < t; i++) {
    printf "\\hline " travel_date[i] " & \\$%'.2f & " travel_desc[i] " \\\\\n", travel_amount[i]  ;
  }

 
  print "\\hline" ;

  print "\\end{tabular}\n\n" ;

 
  printf "Sub-total (Travel): \\$%'.2f\n\n", travel_total ;


  print "\\vfill" ;  

  printf "{\\Large\\textbf{Total due}\\hfill\\$%'.2f}\n\n", travel_total + item_total ;

  print "Please send payment by check to Provider's address within 30 business days." ;

  print "\\end{document}" ;
}
