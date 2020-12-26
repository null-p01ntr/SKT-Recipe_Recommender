import javax.swing.JOptionPane;
import java.util.*;

public class products
{
	public products() throws Exception
	{
		String selectionInput=null;
		int selectionInputINT=0;
		
		List<productObject> productList = new ArrayList<productObject>();
		
		do
		{	
			String Menu="";
			for(productsMenu option: productsMenu.values())
			{	
				Menu+=option.getNum();
				Menu+=option.getDesc();
			}
			
			selectionInput=JOptionPane.showInputDialog(null, skt.productsString+Menu, "Your Products", JOptionPane.PLAIN_MESSAGE);			
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
	private void add()
	{
		
	}
	private void setReminder()
	{
		
	}

}
