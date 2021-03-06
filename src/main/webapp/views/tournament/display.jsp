<%--
 * display.jsp
 *
 * Copyright (C) 2014 Universidad de Sevilla
 * 
 * The use of this project is hereby constrained to the conditions of the 
 * TDG Licence, a copy of which you may download from 
 * http://www.tdg-seville.info/License.html
 --%>

<%@page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>

<%@taglib prefix="jstl" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>
<%@taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@taglib prefix="security"
	uri="http://www.springframework.org/security/tags"%>
<%@taglib prefix="display" uri="http://displaytag.sf.net"%>
<%@taglib prefix="acme" tagdir="/WEB-INF/tags"%>

<form:form action="${requestURI}" modelAttribute="tournamentForm">

	<!-- Tournament title section -->
	<div class="col-xs-12 well spm-tournament-well">
		<span class="glyphicon glyphicon-globe">&nbsp</span> <span
			class="lead"><b><jstl:out value="${tournament.title}" /></b></span>
	</div>

	<!-- Tournament content section -->
	<div class="col-xs-12 well well-sm">
		<div class="col-xs-12 col-sm-5">
			<div>
				<b><spring:message code="tournament.creationMoment" />: </b>
				<fmt:formatDate value="${tournament.creationMoment}"
					pattern="dd/MM/yyyy" />
			</div>

			<div>
				<b><spring:message code="tournament.startMoment" />: </b>
				<fmt:formatDate value="${tournament.startMoment}"
					pattern="dd/MM/yyyy HH:mm" />
			</div>

			<div>
				<b><spring:message code="tournament.sport" />: </b>
				<jstl:out value="${tournament.sport}" />
			</div>

			<div>
				<b><spring:message code="tournament.place" />: </b>
				<jstl:out value="${tournament.place}" />
			</div>

			<div>
				<b><spring:message code="tournament.numberOfTeams" />: </b>
				<jstl:out value="${tournament.numberOfTeams}" />
			</div>
			<div>
				<b><spring:message code="tournament.fee" />: </b>
							<spring:message code="tournament.fee" var="feeHeader" />
							<jstl:out value="${tournament.userFee}" />
			</div>
			<div>
				<b><spring:message code="tournament.prize" />: </b>
				<jstl:out value="${tournament.prize}" />
			</div>
			<jstl:if test="${tournament.customer!=null}">
				<div>
					<b><spring:message code="tournament.place" />: </b>
					<spring:message code="tournament.place" var="placeHeader" />
					<jstl:out value="${tournament.customer.nameCenter}"></jstl:out>
				</div>
				<div>
					<b><spring:message code="tournament.placeplace" />: </b>
					<spring:message code="tournament.placeplace" var="placeHeader" />
					<jstl:out value="${tournament.customer.street}"></jstl:out>
					,
					<jstl:out value="${tournament.customer.city}"></jstl:out>
				</div>

			</jstl:if>
			<jstl:if test="${tournament.customer==null}">
				<div>
					<b><spring:message code="tournament.placeplace" />: </b>
					<spring:message code="tournament.placeplace" var="placeHeader" />
					<jstl:out value="${tournament.place}"></jstl:out>
				</div>
			</jstl:if>
			<div>
				<b><spring:message code="tournament.advertised" />: </b>
				<jstl:if test="${tournament.advertised==true}">
					<spring:message code="tournament.yes" />
				</jstl:if>
				<jstl:if test="${tournament.advertised==false}">
					<spring:message code="tournament.no" />
				</jstl:if>
			</div>

			<div class="col-xs-12 hidden-sm hidden-md hidden-lg">
				<br>
			</div>
		</div>

		<div class="col-xs-12 col-sm-7 alert alert-success">
			<div>
				<b><spring:message code="tournament.description" />: </b>
				<jstl:out value="${tournament.description}" />
			</div>
		</div>
	</div>


	<h3>
		<spring:message code="tournament.teamsPlaying" />
	</h3>

	<div class="table-responsive">
		<display:table name="teams" id="row" pagesize="5"
			class="table table-bordered table-hover">
			<spring:message code="tournament.team.name" var="nameHeader" />
			<display:column property="name" title="${nameHeader}" />

			<spring:message code="tournament.team.maxNumber"
				var="maxNumberHeader" />
			<display:column property="maxNumber" title="${maxNumberHeader}" />
		</display:table>
	</div>


	<h3>
		<spring:message code="tournament.matches" />
	</h3>

	<div class="table-responsive">
		<display:table name="matches" id="row" pagesize="5"
			class="">
		
		<display:column>
			<div class="col-xs-12 spm-search-row">
				<div class="col-xs-12 col-sm-5">
					<div>
						<b><spring:message code="tournament.match.title" />: </b>
						<spring:message code="tournament.match.title" var="titleHeader" />
						<jstl:out value="${row.title}"></jstl:out>
					</div>
					
				</div>
				
				<div class="col-xs-12 col-sm-4">
					<div>
						<b><spring:message code="tournament.match.startMoment" />: </b>
						<spring:message code="tournament.match.startMoment" var="startMomentHeader" />
						<fmt:formatDate value="${row.startMoment}" pattern="dd/MM/yyyy HH:mm" />
					</div>
					
					<div>
						<b><spring:message code="tournament.match.finishMoment" />: </b>
						<spring:message code="tournament.match.finishMoment" var="finishMomentHeader" />
						<fmt:formatDate value="${row.finishMoment}" pattern="dd/MM/yyyy HH:mm" />
					</div>
				</div>
				
				<div class="col-xs-12 col-sm-3">
					<div>
						<b><spring:message code="tournament.match.winner" />: </b>
						<spring:message code="tournament.match.winner" var="winnerHeader" />
						<jstl:out value="${row.winner.name}"></jstl:out>
					</div>
				</div>
			</div>
		</display:column>

		</display:table>
	</div>

	<br>
	<br>

	<security:authorize access="hasRole('CUSTOMER')">
		<acme:cancel code="tournament.back" url="tournament/customer/list.do" />
		<jstl:if test="${miId==tournament.customer.id and puedeEditar}">
			<input type="button" class="btn btn-md btn-success" name="edit"
				value="<spring:message code="tournament.edit"/>"
				onclick="javascript: window.location.replace('tournament/customer/edit.do?tournamentId= ${tournamentId}')" />
		</jstl:if>
	</security:authorize>

	<security:authorize access="hasRole('USER')">
		<acme:cancel code="tournament.back" url="welcome/index.do" />
		<jstl:if test="${miId==tournament.user.id and puedeEditar}">
			<input type="button" class="btn btn-md btn-success" name="edit"
				value="<spring:message code="tournament.edit"/>"
				onclick="javascript: window.location.replace('tournament/user/edit.do?tournamentId= ${tournamentId}')" />
		</jstl:if>
	</security:authorize>

</form:form>