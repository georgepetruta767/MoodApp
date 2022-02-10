import {Component, EventEmitter, OnInit, Output} from '@angular/core';
import {FormControl, FormGroup, Validators} from "@angular/forms";
import {PeopleService} from "../../common/services/people.service";
import {Gender} from "../../common/enums/gender.enum";

@Component({
  selector: 'app-people-add',
  templateUrl: './people-add.component.html',
  styleUrls: ['./people-add.component.scss'],
})
export class PeopleAddComponent implements OnInit {
  @Output()
  public closeModalEvent = new EventEmitter<string>();

  public form!: FormGroup;

  constructor(private peopleService: PeopleService) { }

  ngOnInit() {
    this.setupForm();
  }

  private setupForm() {
    this.form = new FormGroup({
      firstName: new FormControl('', [Validators.required]),
      lastName: new FormControl('', [Validators.required]),
      age: new FormControl('', [Validators.required, Validators.min(0), Validators.max(150)]),
      gender: new FormControl( -1, [Validators.required])
    });
  }

  public async addPerson() {
    if(this.form.valid) {
      await this.peopleService.addPerson({
        firstName: this.form.controls.firstName.value,
        lastName: this.form.controls.lastName.value,
        age: this.form.controls.age.value,
        gender: Number(this.form.controls.gender.value)
      });

      this.emitCloseModalEvent();
    }
  }

  public emitCloseModalEvent() {
    this.closeModalEvent.emit();
  }
}
