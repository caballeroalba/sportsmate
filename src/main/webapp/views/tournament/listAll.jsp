<%--
 * list.jsp
 *
 * Copyright (C) 2014 Universidad de Sevilla
 * 
 * The use of this project is hereby constrained to the conditions of the 
 * TDG Licence, a copy of which you may download from 
 * http://www.tdg-seville.info/License.html
 --%>

<%@page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<?xml version="1.0" encoding="UTF-8"?>
<%@taglib prefix="jstl" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>
<%@taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@taglib prefix="security"
	uri="http://www.springframework.org/security/tags"%>
<%@taglib prefix="display" uri="http://displaytag.sf.net"%>
<%@ taglib prefix="acme" tagdir="/WEB-INF/tags"%>

<div class="table-responsive">
	<div class="spm-table-hook">
	<display:table name="tournaments" id="row" requestURI="${requestURI}"
		pagesize="5" class="">
		
		<display:column property="sport" sortable="true" class="spm-tournaments-sportcolumn">

		</display:column>
		
		<display:column>
			<div class="col-xs-12">
				<div class="alert alert-success spm-no-margin-bottom">
					<spring:message code="tournament.title" var="titleHeader" />
					<jstl:out value="${row.title}"></jstl:out>
				</div>

				<div class="well well-sm col-xs-12 spm-no-margin-bottom">
				
					<div class="col-xs-12 col-md-5">
						<div>
							<b><spring:message code="tournament.startMoment" />: </b>
							<spring:message code="tournament.startMoment"
								var="startMomentHeader" />
							<fmt:formatDate value="${row.startMoment}" pattern="dd/MM/yyyy HH:mm" />
						</div>
						
						<jstl:if test="${row.customer!=null}">
							<div>
								<b><spring:message code="tournament.place" />: </b>
								<spring:message code="tournament.place" var="placeHeader" />
								<jstl:out value="${row.customer.nameCenter}"></jstl:out>
							</div>
							<div>
								<b><spring:message code="tournament.placeplace" />: </b>
								<spring:message code="tournament.placeplace" var="placeHeader" />
								<jstl:out value="${row.customer.street}"></jstl:out>
								,
								<jstl:out value="${row.customer.city}"></jstl:out>
							</div>

						</jstl:if>
						<jstl:if test="${row.customer==null}">
							<div>
								<b><spring:message code="tournament.placeplace" />: </b>
								<spring:message code="tournament.placeplace" var="placeHeader" />
								<jstl:out value="${row.place}"></jstl:out>
							</div>
						</jstl:if>
					</div>

					<div class="col-xs-12 col-md-4">
						<div>
							<b><spring:message code="tournament.sport" />: </b>
							<spring:message code="tournament.sport" var="sportHeader" />
							<jstl:out value="${row.sport}" />
						</div>
						<div>
							<b><spring:message code="tournament.fee" />: </b>
							<spring:message code="tournament.fee" var="feeHeader" />
							<jstl:out value="${row.userFee}" />
						</div>
						<div>
							<b><spring:message code="tournament.numberOfTeams" />: </b>
							<spring:message code="tournament.numberOfTeams"
								var="numberOfTeamsHeader" />
							<jstl:out value="${row.numberOfTeams}" />
						</div>
					</div>

					<div class="col-xs-12 col-md-3">
						<div>
							<b><spring:message code="tournament.advertised" />: </b>
							<spring:message code="tournament.advertised"
								var="advertisedHeader" />
							<jstl:if test="${row.advertised==true}">
								<spring:message code="tournament.yes" />
							</jstl:if>
							<jstl:if test="${row.advertised==false}">
								<spring:message code="tournament.no" />
							</jstl:if>
						</div>

						<div>
							<b><spring:message code="tournament.prize" />: </b>
							<spring:message code="tournament.prize" var="prizeHeader" />
							<jstl:out value="${row.prize}" />
						</div>
						
					</div>
				</div>
				
				
				<!-- HERE STARTS BUTTON SECTION -->
				
				<div class="row spm-spacing-list">
				
						<!-- DETAIL BUTTON -->
						<div class="col-xs-12 col-sm-3">
							<spring:message code="tournament.display" var="displayHeader" />
	
							<security:authorize access="hasRole('USER')">
								<a href="tournament/user/display.do?tournamentId=${row.id}">
									<button type="button" class="btn btn-md btn-default col-xs-12 spm-events-button">
										<spring:message code="tournament.display" />
									</button>
								</a>
							</security:authorize>
	
							<security:authorize access="hasRole('CUSTOMER')">
								<a href="tournament/customer/display.do?tournamentId=${row.id}">
									<button type="button" class="btn btn-md btn-default col-xs-12 spm-events-button">
										<spring:message code="tournament.display" />
									</button>
								</a>
							</security:authorize>
						</div>
						
						<!-- JOIN BUTTON / FULL LABEL / JOINED LABEL -->
						<jstl:if test="${showJoin == true}">
							<security:authorize access="hasRole('USER')">
			
								<div class="col-xs-12 col-sm-3">
									<jstl:if test="${row.teams.size() == row.numberOfTeams }">
										<span class="col-xs-12 bg-danger spm-event-full text-center spm-events-button">
											<spring:message code="tournament.full" var="full" />
											<jstl:out value="${full }"></jstl:out>
										</span>
									</jstl:if>

									<jstl:set var="contains" value="false" />
			
									<jstl:if test="${userTournaments.size() > 0 }">
										<jstl:forEach var="item" items="${userTournaments}">
											<jstl:if test="${item.id eq row.id}">
												<jstl:set var="contains" value="true" />
											</jstl:if>
										</jstl:forEach>
									</jstl:if>
			
									<jstl:if test="${row.teams.size() < row.numberOfTeams }">
										<jstl:if test="${contains == false}">
											<spring:message code="tournament.join" var="join" />
											<a href="tournament/user/chooseATeam.do?tournamentId=${row.id }">
												<button class="btn btn-md btn-success col-xs-12 spm-events-button">
													<jstl:out value="${join }"></jstl:out>
												</button>
											</a>
										</jstl:if>
			
										<jstl:if test="${contains == true}">
											<span class="col-xs-12 bg-success spm-event-joined text-center spm-events-button">
												<spring:message code="tournament.joined" var="joined" />
												<jstl:out value="${joined }"></jstl:out>
											</span>
										</jstl:if>
									</jstl:if>
			
								</div>
			
							</security:authorize>
						</jstl:if>

					
				</div>
			</div>
			
			


			<div class="col-xs-12 spm-spacing-list"></div>

		</display:column>



	</display:table>
	</div>
</div>

<acme:cancel code="tournament.back" url="welcome/index.do" />
