package maper;

import org.apache.hadoop.io.Writable;

import java.io.DataInput;
import java.io.DataOutput;
import java.io.IOException;

public class ValueHolder implements Writable {

    public String league;
    public String citizenship;
    public String nationality;
    public String highestMarketValueDate;
    public Integer marketValue;
    public Integer HighestMarketValue;
    public String team;

    public ValueHolder(String league, String citizenship, String nationality, String highestMarketValueDate, Integer marketValue, Integer highestMarketValue,String team) {
        this.league = league;
        this.citizenship = citizenship;
        this.nationality = nationality;
        this.highestMarketValueDate = highestMarketValueDate;
        this.marketValue = marketValue;
        this.HighestMarketValue = highestMarketValue;
        this.team= team;
    }
    public ValueHolder() {
        this.league = "";
        this.citizenship = "";
        this.nationality = "";
        this.highestMarketValueDate = "";
        this.marketValue = 0;
        this.HighestMarketValue = 0;
        this.team = "";
    }

    @Override
    public void write(DataOutput dataOutput) throws IOException {
        dataOutput.writeUTF(this.league);
        dataOutput.writeUTF(this.citizenship);
        dataOutput.writeUTF(this.nationality);
        dataOutput.writeUTF(this.highestMarketValueDate);
        dataOutput.writeInt(this.marketValue);
        dataOutput.writeInt(this.HighestMarketValue);
        dataOutput.writeUTF(this.team);
    }

    @Override
    public void readFields(DataInput dataInput) throws IOException {
        this.league = dataInput.readUTF();
        this.citizenship = dataInput.readUTF();
        this.nationality = dataInput.readUTF();
        this.highestMarketValueDate = dataInput.readUTF();
        this.marketValue = dataInput.readInt();
        this.HighestMarketValue = dataInput.readInt();
        this.team = dataInput.readUTF();
    }

    @Override
    public String toString() {
        return ","+ league +
                "," + citizenship +
                "," + nationality +
                "," + marketValue +
                "," + HighestMarketValue +
                "," + highestMarketValueDate +
                "," + team;
    }
}
