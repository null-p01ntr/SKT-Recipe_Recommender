import javax.swing.JOptionPane;
import java.util.*;
import com.google.gson.*;
import java.io.FileWriter;
import java.io.IOException;

public class products
{
	Gson gson = new Gson();
	List<productObject> productList = new ArrayList<productObject>();
	
	public products() throws Exception
	{
		String selectionInput=null;
		int selectionInputINT=0;
		
		do
		{	
			String Menu="";
			for(productsMenu option: productsMenu.values())
			{	
				Menu+=option.getNum();
				Menu+=option.getDesc();
			}
			
			selectionInput=JOptionPane.showInputDialog(null, Menu, "Your Products", JOptionPane.PLAIN_MESSAGE);			
			selectionInputINT=Integer.parseInt(selectionInput);
			
			if(selectionInputINT==1) //register
			{
				add();
			}
			else if(selectionInputINT==2) //only login
			{
				setReminder();
			}
		}while(selectionInputINT!=0);
	}
	private void add() throws IOException
	{
		String name=JOptionPane.showInputDialog(null, "Enter Product Name", "Register", JOptionPane.QUESTION_MESSAGE);
		String date=JOptionPane.showInputDialog(null, "Enter Expiry Date", "Register", JOptionPane.QUESTION_MESSAGE);
		
		productObject newProductObject = new productObject();
		//newProductObject.index=0;
		newProductObject.name=name;
		newProductObject.date=date;
		newProductObject.remind=2;
		
		//add to product list
		String json = gson.toJson(newProductObject);
	    FileWriter writer = new FileWriter("database.json");
	    writer.write(json);
	    writer.close();
	}
	private void setReminder()
	{
		
	}

}
