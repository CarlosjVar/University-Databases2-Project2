//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by FernFlower decompiler)
//

package reducer;

import java.io.IOException;
import java.util.Iterator;

import maper.ValueHolder;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Reducer;

public class SimpleReducer extends Reducer<Text, ValueHolder, Text, ValueHolder> {
    private IntWritable result = new IntWritable();

    public SimpleReducer() {
    }

    public void reduce(Text key, Iterable<ValueHolder> values, Reducer<Text, ValueHolder, Text, ValueHolder>.Context context) throws IOException, InterruptedException {
        Iterator var6 = values.iterator();
        ValueHolder valueHolder = (ValueHolder) var6.next();
        //Our valueHolder holds all the required atributes of a player , we can filter by any of these attributes , here we did it by nationality
        if(valueHolder.nationality.equals("Italy"))
        {
            context.write(key, valueHolder);
        }

    }
}
