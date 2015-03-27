package services;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Date;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.Assert;
import repositories.EventRepository;
import domain.Actor;
import domain.Customer;
import domain.Event;
import domain.User;
import forms.EventForm;

@Service
@Transactional
public class EventService {
	
	//Managed repository -----------------------------------------------------
	@Autowired
	private EventRepository eventRepository;
	
	// Supporting services ---------------------------------------------------
	@Autowired
	private UserService userService;
	
	@Autowired
	private CustomerService customerService;
	
	@Autowired
	private ActorService actorService;
	
	// Constructors-----------------------------------------------------------
	public EventService()
	{
		
		super();		
		
	}
	
	// Simple CRUD methods ---------------------------------------------------
	
	public Collection<Event>  findAll()
	{
		
		Collection<Event> all;
		
		all = eventRepository.findAll();
		
		return all;
		
	}
	
	public Event findOne(int eventId) 
	{
		
		Event result;
		
		result = eventRepository.findOne(eventId);
		
		return result;
		
	}
	
	public Event create()
	{
		
		Event event;
		Actor actor;
		User owner;
		Customer customer;
		Collection<User> users;
		Date creationMoment;
		long miliseconds;
		
		event = new Event();
		actor = actorService.findByPrincipal();
		users = new ArrayList<User>();
		miliseconds = System.currentTimeMillis()-3;
		creationMoment = new Date(miliseconds);
		
		if(actor instanceof User){
			
			owner = (User)actor;
			
			event.setOwner(owner);
			
		}else if(actor instanceof Customer){
			
			customer = (Customer)actor;
			
			event.setCustomer(customer);
		}
		
		event.setCreationMoment(creationMoment);
		event.setUsers(users);
		
		return event;
		
	}
	
	public void save(Event event)
	{
		
		User owner;
		Customer customer;
		
		Assert.notNull(event);
		Assert.isTrue(event.getStartMoment().compareTo(event.getFinishMoment()) < 0);
		
		eventRepository.save(event);
		
		if(actorService.findByPrincipal() instanceof User){
			
			owner = (User)actorService.findByPrincipal();
			owner.getEventsCreated().add(event);
			userService.save(owner);
			
		}else if(actorService.findByPrincipal() instanceof Customer){
			
			customer = (Customer)actorService.findByPrincipal();
			customer.getEvents().add(event);
			customerService.save(customer);
		}		
		
	}
	
	public void delete(Event event)
	{
		User owner;
		Customer customer;
		
		Assert.notNull(event);
		checkPrincipalByActor(event);
		Assert.isTrue(event.getUsers().size()==1);
		
		if(actorService.findByPrincipal() instanceof User){
			
			owner = (User)actorService.findByPrincipal();
			owner.getEventsCreated().remove(event);
			userService.save(owner);
			
		}else if(actorService.findByPrincipal() instanceof Customer){
			
			customer = (Customer)actorService.findByPrincipal();
			customer.getEvents().remove(event);
			customerService.save(customer);			
		}
		
		eventRepository.delete(event);
		
	}
	
	//Other business methods ------------------------------------------------
	
	public void checkPrincipalByActor(Event event)
	{
		
		Actor actor;
		User owner;
		Customer customer;
		
		actor = actorService.findByPrincipal();
		
		if(actor instanceof User){
			owner = (User)actor;
			Assert.isTrue(event.getOwner().equals(owner));
		}else if(actor instanceof Customer){
			customer = (Customer)actor;
			Assert.isTrue(event.getCustomer().equals(customer));
		}		
		
	}
	
	public Event findOneToEdit(int eventId)
	{
		
		Event event;
		
		event = eventRepository.findOne(eventId);	
		
		checkPrincipalByActor(event);
		
		return event;
		
	}	

	
	public Collection<Event> findAllEventsByUserId()
	{
		
		Collection<Event> all;
		User user;
		int userId;
		
		user = userService.findByPrincipal();
		userId = user.getId();
		all = eventRepository.findAllEventsByUserId(userId);
		
		return all;
		
	}
	
	public Collection<Event> findAllEventsByCustomerId()
	{
		
		Collection<Event> all;
		Customer customer;
		int customerId;
		
		customer = customerService.findByPrincipal();
		customerId = customer.getId();
		all = eventRepository.findAllEventsByCustomerId(customerId);
		
		return all;
		
	}
	
	public Collection<String> sports()
	{
		
		Collection<String> all;
		
		all = new ArrayList<String>();
		
		all.add("FOOTBALL"); all.add("TENNIS"); all.add("BASKETBALL"); all.add("FUTSAL");
		all.add("RACE"); all.add("PADDLE"); all.add("FOOTBALL_7"); 
		
		return all;
		
	}
	
	public Collection<String> places()
	{
		
		Collection<String> all;
		
		all = new ArrayList<String>();
		
		all.add("IndorClub"); all.add("SportClub"); all.add("Place 3"); all.add("Place 4"); all.add("Place 5");
		all.add("Place 6"); all.add("Place 7"); all.add("Place 8"); all.add("Place 9"); all.add("Other center");
		
		
		return all;
		
	}
	
	public EventForm construct(Event event)
	{
		
		EventForm result;
		
		result = new EventForm();
		
		result.setId(event.getId());
		result.setTitle(event.getTitle());
		result.setStartMoment(event.getStartMoment());
		result.setFinishMoment(event.getFinishMoment());
		result.setDescription(event.getDescription());
		result.setNumberMaxParticipant(event.getNumberMaxParticipant());
		result.setSport(event.getSport());
		result.setPlace(event.getPlace());
		
		return result;
		
	}
	
	public Event reconstruct(EventForm eventForm)
	{
		
		Event event;
		
		if(eventForm.getId() != 0){
			event = eventRepository.findOne(eventForm.getId());
			
			checkPrincipalByActor(event);
		}else{
			event = this.create();
		}
		
		event.setId(eventForm.getId());
		event.setStartMoment(eventForm.getStartMoment());
		event.setFinishMoment(eventForm.getFinishMoment());
		event.setTitle(eventForm.getTitle());
		event.setDescription(eventForm.getDescription());
		event.setNumberMaxParticipant(eventForm.getNumberMaxParticipant());
		event.setSport(eventForm.getSport());
		
		if(!eventForm.getOtherSport().isEmpty()){
			event.setPlace(eventForm.getOtherSport());
		}else{
			event.setPlace(eventForm.getPlace());	
		}		
		
		return event;
		
	}
}



	


	



	
	

	