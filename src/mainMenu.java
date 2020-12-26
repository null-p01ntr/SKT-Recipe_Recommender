
public enum mainMenu
{
	one("(1)", "Products\n"), 
	two("(2)", "Search\n"),
	zero("(0)", "Exit\n");
	
	private final String num;
	private final String desc;
	
	mainMenu(String number, String description)
	{
		num=number;
		desc=description;
	}
	
	public String getNum()
	{
		return num;
	}
	
	public String getDesc()
	{
		return desc;
	}
}
