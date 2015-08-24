<%@page import="br.com.copacabana.cb.entities.MealOrder"%>
<%@page import="br.copacabana.spring.OrderManager"%>
<%@page import="br.com.copacabana.cb.entities.Restaurant"%>
<%@page import="br.copacabana.spring.RestaurantManager"%>
<%@page import="br.com.copacabana.cb.entities.Central"%>
<%@page import="br.com.copacabana.cb.entities.mgr.CentralManager"%>
<%@page import="br.com.copacabana.cb.entities.Address"%>
<%@page import="br.com.copacabana.cb.entities.Client"%>
<%@page import="java.util.Iterator"%>
<%@page import="br.copacabana.spring.ClientManager"%>
<%@page import="java.util.Set"%>
<%@page import="java.util.HashSet"%>
<%@page import="com.google.appengine.api.datastore.Key"%>
<%@page import="br.copacabana.spring.AddressManager"%>
<%@page import="br.copacabana.EntityManagerBean"%>
<%@page import="br.copacabana.usecase.CityIdentifier"%>
<%
ClientManager cman = new ClientManager();
Set<Key> all = new HashSet<Key>();
Set<Key> clients = new HashSet<Key>();
Set<Key> rests = new HashSet<Key>();
Set<Key> centrais = new HashSet<Key>();
Set<Key> orders = new HashSet<Key>();

for(Iterator<Client> iter = cman.list().iterator();iter.hasNext();){
	Client c = iter.next();	
	clients.addAll(c.getAddresses());
}
CentralManager cenMan = new CentralManager();
for(Iterator<Central> iter = cenMan.list().iterator();iter.hasNext();){
	Central c = iter.next();
	if(c.getMainAddress()!=null){
	centrais.add(c.getMainAddress());
	}
}

RestaurantManager restMan = new RestaurantManager();
for(Iterator<Restaurant> iter = restMan.list().iterator();iter.hasNext();){
	Restaurant c = iter.next();
	if(c.getAddress()!=null){
		rests.add(c.getAddress());
	}
}

OrderManager omanMan = new OrderManager();
for(Iterator<MealOrder> iter = omanMan.list().iterator();iter.hasNext();){
	MealOrder c = iter.next();
	if(c.getAddress()!=null){
		orders.add(c.getAddress());
	}
}
%>Centrais contem <b><%=centrais.size() %></b> enderecos diferentes<br>
rests contem <b><%=rests.size() %></b> enderecos diferentes<br>
orders contem <b><%=orders.size() %></b> enderecos diferentes<br>
clients contem <b><%=clients.size() %></b> enderecos diferentes<br><%

all.addAll(centrais);
all.addAll(rests);
all.addAll(clients);
all.addAll(orders);
AddressManager addman = new AddressManager();
int coutner = 0;
int total = 0;
for(Iterator<Address> iter = addman.list().iterator();iter.hasNext();){
	Address add = iter.next();
	if(all.contains(add.getId())==false){
		if("true".equals(request.getParameter("debug"))){
			out.println("<br> "+(coutner++)+" "+add.getStreet()+", "+add.getNeighborhood().getCity().getName());
		}
		coutner++;
	}else{
		total++;
	}
}

%><br>Deveria apagar: <%=coutner%> de <%=addman.list().size()%>