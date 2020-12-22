package maper;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.StringTokenizer;

import org.apache.hadoop.io.FloatWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Mapper;

public class SimpleMaper extends Mapper<Object, Text, Text, FloatWritable> {
   public void map(Object key, Text value, Context context) throws IOException, InterruptedException
   {
     StringTokenizer itr = new StringTokenizer(value.toString(), ",");
     while (itr.hasMoreTokens()) 
     {
    	 try 
    	 {
    		 String monto = itr.nextToken();
    		 String fechastr = itr.nextToken();
    		 System.out.println(monto);
    		 Float amount = Float.parseFloat(monto);
    		 Date fecha = new SimpleDateFormat("MM/dd/yyyy").parse(fechastr);
    		 Text nameofmonth = new Text(new SimpleDateFormat("MMM").format(fecha));
        	 FloatWritable amountToWrite = new FloatWritable(amount);        	 
        	 context.write(nameofmonth, amountToWrite);
    	 } 
    	 catch (Exception ex) 
    	 {
    		 System.out.println(ex.getMessage());
    	 }
     }
   }
}
