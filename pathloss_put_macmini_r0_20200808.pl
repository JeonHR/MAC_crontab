####################################################################################################
# get_pathloss_form_macmini_[rev]_[date]pl
# test perl : strawberry perl v5.28.1
####################################################################################################
# 2020/08/08, Start of development - HJ.Lee
# 2020/08/08, Init release - HJ.Lee
####################################################################################################
# [Procedure of perl]
# windows setting : install strawberry perl (v5.28.1)
# macmini setting : change 'cm' account type from 'standard' to 'admin'
# Revision 23-07-23 By HR.jeon
####################################################################################################


##############################
# Variables
##############################

  $tot_site = 16;

  for($site=1;$site<=$tot_site;$site++){

    $site_val=$site + 99;
    $macmini_ip = "192.168.100.".$site_val;
#  print $site_val, "\n"; # verify for value
#  print $macmini_ip, "\n"; # verify for value

##################################################
# disconnect & connect macmini network drive
##################################################
    ### site 별 drive 및 ip 설정
    @drive_map=("i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","y");

    print "##################################################\n"; # verify for value
    print "### disconnect ".@drive_map[$site_val-100]." drive(eagle account)"."\n"; # verify for value
    !system('net use '.@drive_map[$site_val-100].': /delete /y');
    print "##################################################\n\n"; # verify for value
    sleep(1); # waittime - sec

    print "##################################################\n"; # verify for value
    print "### connect ".@drive_map[$site_val-100]." drive(cm account)"."\n"; # verify for value
    !system('net use '.@drive_map[$site_val-100].': \\\\'.$macmini_ip.'"\\Macintosh HD\\Users\\cm\\Desktop\\JD" /user:cm cmcm');
    print "##################################################\n\n"; # verify for value
    sleep(1); # waittime - sec

##################################################
### pathloss file backup in macmini
##################################################

    print "### local script.sh -> mac script.sh"."\n"; # verify for value
    !system('copy script.sh '.@drive_map[$site_val-100].':\ /y');


##################################################
# disconnect & connect macmini network drive
##################################################
    print "##################################################\n"; # verify for value
    print "### disconnect ".@drive_map[$site_val-100]." drive(cm account)"."\n"; # verify for value
    !system('net use '.@drive_map[$site_val-1].': /delete /y');
    print "##################################################\n\n"; # verify for value
    sleep(1); # waittime - sec

    print "##################################################\n"; # verify for value
    print "### connect ".@drive_map[$site_val-100]." drive(eagle account)"."\n"; # verify for value
    !system('net use '.@drive_map[$site_val-100].': \\\\'.$macmini_ip.'\\eagle /user:eagle eagle123');
    print "##################################################\n\n"; # verify for value
    sleep(1); # waittime - sec

  }

exit;



# +-----------------+
# | Sub-Routines    |
# +-----------------+

sub get_current_path{
  ### Input variable  ###
  # $os_type -> windows | unix | linux
  ### Output variable ###
  # $current_path -> current path(pwd)

  $current_path=""; #init variable
  my $os_type = scalar(@_[0]);
#  print $os_type, "\n"; # verify for value

  $current_path = ($os_type eq "windows") ? `cd` : `pwd`;
  $current_path =~ s/^\s+|\s+$//g; #공백 문자 제거
#  print $current_path, "\n"; # verify for value

  return $current_path;
}

sub search_dir_n_listup_files{
  ### Input variable  ###
  # $dir_path -> directory path
  ### Output variable ###
  # @return_array -> file names in input_path

  @return_array=(); #init variable
  my $dir_path = scalar(@_[0]);
  opendir(DIR,"$dir_path") or die "Cannot open $dir_path\n";
  my @return_array = readdir(DIR);
  closedir(DIR);

  return @return_array;
}

sub choose_variables_in_array{
  ### Input variable  ###
  # $search_str -> reference str to save array_variable
  # @_[1~] -> original array_variable
  ### Output variable ###
  # @return_array -> file names with $search_str

  @return_array=(); #init variable
  my $search_path = scalar(@_[0]);
  my $search_str = scalar(@_[1]);
#  print $#_, "\n";

  for($i=2,$j=0;$i<=$#_;$i++){
    @_[$i] =~ s/^\s+|\s+$//g; #공백 문자 제거
    my $search_path_name = $search_path."\\".scalar(@_[$i]);
#  print $search_path_name, "\n";
    if((-s $search_path_name) and (@_[$i] =~ /$search_str$/))
      { @return_array[$j] = @_[$i]; $j+=1; }
  }

  return @return_array;
}

sub read_line_in_file{
  ### Input variable  ###
  # $read_line -> number of reading line that you want || "all"
  # $file_path_name -> file path and name
  ### Output variable ###
  # @return_array -> each lines value

  @return_array=(); #init variable
  my $read_line = scalar(@_[0]);
  my $file_path_name = scalar(@_[1]);

  if($read_line eq "all"){
    open( fileHandle, "<".$file_path_name ) || die "$file_path_name\n"; # file open
    @return_array = <fileHandle>;
    close( fileHandle ); # file close
  }

  else{
    my $i=0;
    open( fileHandle, "<".$file_path_name ) || die "$file_path_name\n"; # file open
    while (<fileHandle>) {
      if ($i >= $read_line) { last; }
#      print $_; # verify for value
      @return_array[$i] = $_;
      $i+=1;
    }
  }
  close fileHandle;

  return @return_array;
}

sub search_split_mark_in_line{
  # : 찾고자 하는 문자열이 포함된 Line_Number을 리턴한다.
  ### Input variable  ###
  # $search_str -> reference str to save array_variable
  # @_[1~] -> original array_variable
  ### Output variable ###
  # @return_array -> mark line numbers

  @return_array=(); #init variable
  my $search_str = scalar(@_[0]);
#  print $#_, "\n";

  for($i=1,$j=0;$i<=$#_;$i++){
    @_[$i] =~ s/^\s+|\s+$//g; #공백 문자 제거
    if($read_line eq "none")
      { @return_array[$j] = $i-1; $j+=1; }
    elsif(@_[$i] =~ /$search_str/)
      { @return_array[$j] = $i-1; $j+=1; }
  }

  return @return_array;
}

sub search_split_mark_in_line2{
  ### Input variable  ###
  # $search_str -> reference str to save array_variable
  # @_[1~] -> original array_variable
  ### Output variable ###
  # @return_array -> mark line numbers2

  @return_array=(); #init variable
  my $search_str = scalar(@_[0]);
#  print $#_, "\n";
  my $comp_value=0;

  for($i=1,$j=0;$i<=$#_;$i++){
#    @_[$i] =~ s/^\s+|\s+$//g; #공백 문자 제거
    $a=@_[$i]+1;
#    @_[$i+1] =~ s/^\s+|\s+$//g; #공백 문자 제거
    $b=@_[$i+1];
    if($a eq $b)
      { @return_array[$j] = @_[$i]; $j+=1; }
  }

  return @return_array;
}

sub search_split_mark_in_line_rohxxx_cw_cal{
  ### Input variable  ###
  # $search_str -> reference str to save array_variable
  # @_[1~] -> original array_variable
  ### Output variable ###
  # @return_array -> mark line numbers

  @return_array=(); #init variable
  my $search_str1 = scalar(@_[0]);
  my $search_str2 = scalar(@_[1]);
  my $search_str3 = scalar(@_[2]);
#  print $#_, "\n";

  for($i=3,$j=0;$i<=$#_;$i++){
    @_[$i] =~ s/^\s+|\s+$//g; #공백 문자 제거
    if($read_line eq "none")
      { @return_array[$j] = $i-3; $j+=1; }
    elsif(@_[$i] =~ /$search_str1/)
      { @return_array[$j] = $i-3; $j+=1; }
    elsif(@_[$i] =~ /$search_str2/)
      { @return_array[$j] = $i-3; $j+=1; }
    elsif(@_[$i] =~ /$search_str3/)
      { @return_array[$j] = $i-3; $j+=1; }
  }

  return @return_array;
}

sub write_merge_data{
  ### Input variable  ###
  # $read_line -> number of reading line that you want || "all"
  # $file_path_name -> file path and name
  ### Output variable ###
  # @return_array -> each lines value

  @return_array=(); #init variable
  my $file_path_name = scalar(@_[0]);
#  print $file_path_name, "\n"; # verify for value

      # save files (pass/fail)
      $writing_file_name = $file_path_name;
      open( fileHandle, ">", $writing_file_name ) || die "Cannot open $writing_file_name\n"; # file open
      for($i=1;$i<=$#_;$i++)
      {
        print fileHandle @_[$i]."\n";
#  print @_[$i], "\n"; # verify for value
      }
      close fileHandle; # file close

  return @return_array;
}

sub search_remove_mark_in_line{
  ### Input variable  ###
  # $search_str -> reference str to save array_variable
  # @_[1~] -> original array_variable
  ### Output variable ###
  # @return_array -> mark line numbers

  @return_array=(); #init variable
  my $search_str = scalar(@_[0]);
#  print $#_, "\n";

  for($i=1,$j=0;$i<=$#_;$i++){
    @_[$i] =~ s/^\s+|\s+$//g; #공백 문자 제거
    if($read_line eq "none")
      { @return_array[$j] = $i-1; $j+=1; }
    elsif(@_[$i] =~ /$search_str/)
      {  }
    else
      { @return_array[$j] = $i-1; $j+=1; }
  }

  return @return_array;
}

sub mks_lp_summmary{
  ### Input variable  ###
  # $search_str -> reference str to save array_variable
  # @_[1~] -> original array_variable
  ### Output variable ###
  # @return_array -> mark line numbers2

  @return_array=(); #init variable
  $split_buf1="SB,";
  $split_buf2="HB,";
  $split_buf3="BD,";
  $split_buf4="BV,";

  my $str_line_val = scalar(@_[0]);
  my $stp_line_val = scalar(@_[1]);
#  print $#_, "\n";

  for($i=$str_line_val+2,$j=0;$i<=$stp_line_val+2;$i++){

#  print @_[$i], "\n";
    @_[$i] =~ s/^\s+|\s+$//g; #공백 문자 제거
#org_code    @split_buf = split(/    +/, @_[$i]);
    @split_buf = split(/   +/, @_[$i]); # deb_code, 19/06/19 HJ.Lee, split_value 공백4자 -> 공백3자로 변경
#  print "@return_array", "\n";
    $split_buf1 = $split_buf1 . @split_buf[0] . ","; ### Software Binning
    $split_buf2 = $split_buf2 . @split_buf[1] . ","; ### Hardware Binning
    $split_buf3 = $split_buf3 . @split_buf[2] . ","; ### Bin description
    $split_buf4 = $split_buf4 . @split_buf[3] . ","; ### Bin value
  }

@return_array[0] = $split_buf1;
@return_array[1] = $split_buf2;
@return_array[2] = $split_buf3;
@return_array[3] = $split_buf4;


  return @return_array;
}

sub split_line_and_save_to_array{
  ### Input variable  ###
  # $search_str -> reference str to save array_variable
  # @_[1~] -> original array_variable
  ### Output variable ###
  # @return_array -> mark line numbers2

  @return_array=(); #init variable
  my $ref_line = scalar(@_[0]);
#  print $#_, "\n";

  @return_array = split(/,/, $ref_line);

  for($i=1;$i<=$#return_array;$i++){
    @return_array[$i] =~ s/^\s+|\s+$//g; #공백 문자 제거
  }

  return @return_array;
}

sub make_jmp_script{
  ### Input variable  ###
  # input0: ref_info_title
  # input1: ref_info_min_range
  # input2: ref_info_max_range
  # input3: ref_info_inc_range
  # input4: ref_info_lsl_limit
  # input5: ref_info_usl_limit
  # input6: $output_file_pwd
  # input7: $output_file_name
  ### Output variable ###
  # @return_array -> mark line numbers2

  @return_array=(); #init variable
  my $ref_info_title = scalar(@_[0]);
  my $ref_info_min_range = scalar(@_[1]);
  my $ref_info_max_range = scalar(@_[2]);
  my $ref_info_inc_range = scalar(@_[3]);
  my $ref_info_lsl_limit = scalar(@_[4]);
  my $ref_info_usl_limit = scalar(@_[5]);
  my $picture_save_path = scalar(@_[6]);
  my $picture_save_name = scalar(@_[7]);

#  print $#_, "\n";
#  print "@_", "\n"; # verify for value

### Sample of JMP Example ###
# // Make Distribution
# Distribution(
#   // Summary Statistics Settings..
#   Continuous Distribution(
#     Column( :Name( "26. UWB_RX_VERIFY BAD (CN23)" ) ),
#     Customize Summary Statistics(
#       Std Err Mean( 0 ),
#       Upper Mean Confidence Interval( 0 ),
#       Lower Mean Confidence Interval( 0 ),
#       Minimum( 1 ),
#       Maximum( 1 )
#     )
#   ),
#   // Axis Settings..
#   SendToReport(
#     Dispatch(
#       {"26. UWB_RX_VERIFY BAD (CN23)"},
#       "1",
#       ScaleBox,
#       {Min( -10 ), Max( 210 ), Inc( 20 ), Minor Ticks( 1 ),
#       Add Ref Line( 0, "Solid", {255, 0, 0}, "LSL", 1 ),
#       Add Ref Line( 20, "Solid", {255, 0, 0}, "USL", 1 )}
#     ),
#     Dispatch(
#       {"26. UWB_RX_VERIFY BAD (CN23)"},
#       "Quantiles",
#       OutlineBox,
#       {Close( 1 )}
#     )
#   )
# );

  @return_array[0]  = "// Make Distribution";
  @return_array[1]  = "tget=Distribution(";
  @return_array[2]  = "  // Summary Statistics Settings..";
  @return_array[3]  = "  Continuous Distribution(";
  @return_array[4]  = "    Column( :Name( \"".$ref_info_title."\" ) ),";
  @return_array[5]  = "    Customize Summary Statistics(";
  @return_array[6]  = "      Std Err Mean( 0 ),";
  @return_array[7]  = "      Upper Mean Confidence Interval( 0 ),";
  @return_array[8]  = "      Lower Mean Confidence Interval( 0 ),";
  @return_array[9]  = "      Minimum( 1 ),";
  @return_array[10] = "      Maximum( 1 )";
  @return_array[11] = "    )";
  @return_array[12] = "  ),";
  @return_array[13] = "  // Axis Settings..";
  @return_array[14] = "  SendToReport(";
  @return_array[15] = "    Dispatch(";
  @return_array[16] = "      {\"".$ref_info_title."\"},";
  @return_array[17] = "      \"1\",";
  @return_array[18] = "      ScaleBox,";
  @return_array[19] = "      {Min( ".$ref_info_min_range." ), Max( ".$ref_info_max_range." ), Inc( ".$ref_info_inc_range." ), Minor Ticks( 1 ),";
  @return_array[20] = "      Add Ref Line( ".$ref_info_lsl_limit.", \"Solid\", {255, 0, 0}, \"LSL\", 1 ),   ";
  @return_array[21] = "      Add Ref Line( ".$ref_info_usl_limit.", \"Solid\", {255, 0, 0}, \"USL\", 1 )}  ";
  @return_array[22] = "    ),";
  @return_array[23] = "    Dispatch(";
  @return_array[24] = "      {\"".$ref_info_title."\"},";
  @return_array[25] = "      \"Quantiles\",";
  @return_array[26] = "      OutlineBox,";
  @return_array[27] = "      {Close( 1 )}";
  @return_array[28] = "    )";
  @return_array[29] = "  )";
  @return_array[30] = ");";
  @return_array[31] = "report(tget) << save picture(\"".$picture_save_path."\\".$ref_info_title.".png\", \"png\");";
  @return_array[32] = "\n";

# $picture_save_path
#  for($i=1;$i<=$#return_array;$i++){
#    @return_array[$i] =~ s/^\s+|\s+$//g; #공백 문자 제거
#  }
#  print "@return_array", "\n"; # verify for value

  return @return_array;
}
