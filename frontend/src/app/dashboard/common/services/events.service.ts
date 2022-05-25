import { Injectable } from '@angular/core';
import {HttpClient, HttpHeaders} from '@angular/common/http';
import {EventModel} from '../models/event.model';
import {environment} from '../../../../environments/environment';

@Injectable({
  providedIn: 'root'
})
export class EventsService {

  constructor(private http: HttpClient) { }

  public addEvent(eventModel: EventModel): Promise<any> {
    return this.http.post(`${environment.api}/Events/Add`, eventModel, {
      headers: new HttpHeaders({
        'Authorization': `Bearer ${sessionStorage.getItem('bearerToken')}`
      })
    }).toPromise();
  }

  public getEvents(): Promise<Array<EventModel>> {
    return this.http.get<Array<EventModel>>(`${environment.api}/Events/Get`, {
      headers: new HttpHeaders({
        'Authorization': `Bearer ${sessionStorage.getItem('bearerToken')}`
      })
    }).toPromise();
  }

  public getEventsByDate(eventsDate: Date): Promise<Array<EventModel>> {
    return this.http.get<Array<EventModel>>(`${environment.api}/Events/GetEventsByDate?date=${eventsDate.toString().slice(0, 10)}`, {
      headers: new HttpHeaders({
        'Authorization': `Bearer ${sessionStorage.getItem('bearerToken')}`
      })
    }).toPromise();
  }

  public getEventById(eventId: string): Promise<EventModel> {
    return this.http.get<EventModel>(`${environment.api}/Events/GetEventById?id=${eventId}`, {
      headers: new HttpHeaders({
        'Authorization': `Bearer ${sessionStorage.getItem('bearerToken')}`
      })
    }).toPromise();
  }

  public updateEvent(eventModel: EventModel): Promise<any> {
    return this.http.post<any>(`${environment.api}/Events/Update`, eventModel, {
      headers: new HttpHeaders({
        'Authorization': `Bearer ${sessionStorage.getItem('bearerToken')}`
      })
    }).toPromise();
  }

  public deleteEvent(eventId: string): Promise<any> {
    return this.http.delete(`${environment.api}/Events/Delete?id=${eventId}`, {
      headers: new HttpHeaders({
        'Authorization': `Bearer ${sessionStorage.getItem('bearerToken')}`
      })
    }).toPromise();
  }
}
