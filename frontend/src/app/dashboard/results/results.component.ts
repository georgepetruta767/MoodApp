import {Component} from '@angular/core';
import * as echarts from 'echarts';
import {ResultService} from './result.service';
import {SecurityService} from '../common/services/security.service';
import {FormBuilder, FormControl, FormGroup, Validators} from '@angular/forms';

type EChartsOption = echarts.EChartsOption;

@Component({
  selector: 'app-results',
  templateUrl: './results.component.html',
  styleUrls: ['./results.component.scss'],
})
export class ResultsComponent {
  public barChartOption: EChartsOption;

  public scatterChartOption: EChartsOption;

  public lineChartOption: EChartsOption;

  public pieChartOption: EChartsOption;

  public barChartForm!: FormGroup;

  public pieChartForm!: FormGroup;

  public lineChartForm!: FormGroup;

  public userId: string;

  constructor(private resultsService: ResultService,
              private accountService: SecurityService,
              private formBuilder: FormBuilder) { }

  public async ionViewWillEnter() {
    this.setupForms();

    this.userId = await this.accountService.getUserId();
    await this.loadBarChart();
    await this.loadScatterChart();
    await this.loadLineChart();
    await this.loadPieChart();
  }

  public async loadBarChart() {
    this.barChartOption = await this.resultsService.getBarChartOptions(this.barChartForm.controls.category.value, this.barChartForm.controls.type.value, this.userId);
  }

  public async loadScatterChart() {
    this.scatterChartOption = await this.resultsService.getScatterChartOptions('amount_spent', 'grade', this.userId);
  }

  public async loadLineChart() {
    this.lineChartOption = await this.resultsService.getLineChartOptions(this.lineChartForm.controls.year.value, this.lineChartForm.controls.month.value, -1, this.userId);
  }

  public async loadPieChart() {
    if(!this.pieChartForm.valid) {
      return;
    }

    this.pieChartOption = await this.resultsService.getPieChartOptions(this.pieChartForm.controls.top.value, this.pieChartForm.controls.nrPeople.value, this.userId);
  }

  public async clearYearControl() {
    console.log('sdgdgsdg');
    this.lineChartForm.controls.year.setValue(-1);
    await this.loadLineChart();
  }

  public async clearMonthControl() {
    console.log('month')
    this.lineChartForm.controls.month.setValue(-1);
    await this.loadLineChart();
  }

  private setupForms() {
    this.barChartForm = this.formBuilder.group({
      type: new FormControl('mean', [Validators.required]),
      category: new FormControl('season', [Validators.required])
    });

    this.pieChartForm = this.formBuilder.group({
      top: new FormControl(true, [Validators.required]),
      nrPeople: new FormControl(3, [Validators.required])
    });

    this.lineChartForm = this.formBuilder.group({
      year: new FormControl(-1),
      month: new FormControl(-1)
    });
  }
}
