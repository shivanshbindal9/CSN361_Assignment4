BEGIN{
drop=0;
}
{
if($1=="d" )
 {
 drop++;
 }
}
END{
printf("Total number of packets dropped due to congestion = %d\n",drop);
}