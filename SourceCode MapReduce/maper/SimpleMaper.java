//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by FernFlower decompiler)
//

package maper;

import java.io.DataInput;
import java.io.DataOutput;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.Date;
import java.util.StringTokenizer;

import com.sun.xml.internal.messaging.saaj.util.TeeInputStream;
import org.apache.hadoop.io.FloatWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.Writable;
import org.apache.hadoop.mapreduce.Mapper;

public class SimpleMaper extends Mapper<Object, Text, Text, ValueHolder> {
    public static int cuenta = 0;
    public SimpleMaper() {
    }

    public void map(Object key, Text value, Mapper<Object, Text, Text,ValueHolder>.Context context) throws IOException, InterruptedException {
        String[] result = value.toString().split("\\,",-1);
            try {
                String playerName = result[1];
                String league =  result[3];
                String citizenship =  result[9];
                String nationality = result[26];
                String highestMarketValueDate= "";

                int marketValueInt = 0;
                int highestMarketValueInt = 0;
                int marketValueIndex = 0;

                int nacionalityStartIndex = 26;
                while (true)
                {
                    if (!nationality.isEmpty()){
                        break;
                    }
                    nacionalityStartIndex++;
                    nationality =  result[nacionalityStartIndex];
                }
                //We try to find if value is an Integer
                try
                {
                    marketValueIndex= 29;

                    marketValueInt = Integer.parseInt(result[marketValueIndex]);
                    highestMarketValueInt = Integer.parseInt(result[marketValueIndex+4]);
                    highestMarketValueDate = result[marketValueIndex+5];
                }
                //If it isn't , then the previous value was the one we wanted
                catch (NumberFormatException e)
                {
                    marketValueIndex= 28;

                    marketValueInt = Integer.parseInt(result[marketValueIndex]);
                    highestMarketValueInt = Integer.parseInt(result[marketValueIndex+4]);
                    highestMarketValueDate = result[marketValueIndex+5];
                }
                //If our marketvalue is less than 50 , that means we have the wrong column
                if (marketValueInt< 50){
                    marketValueIndex = 30;

                    marketValueInt = Integer.parseInt(result[marketValueIndex]);
                    highestMarketValueInt = Integer.parseInt(result[marketValueIndex+4]);
                    highestMarketValueDate = result[marketValueIndex+5];
                }

                //We create our key and value for the context
                Text playerNameText = new Text(playerName);
                //This is a way of passing multiple values with a single key, valueHolder is an object that implements the writable interface, with this method ,
                //you can pass a class with multible atributes as a value
                ValueHolder valueHolder = new ValueHolder(league,citizenship,nationality,highestMarketValueDate,marketValueInt,highestMarketValueInt);
                context.write(playerNameText,valueHolder);
            } catch (Exception var11) {
                System.out.println(Arrays.toString(var11.getStackTrace()));
            }


    }
}
