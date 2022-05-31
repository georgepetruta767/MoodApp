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

  public scatterPlotOption: EChartsOption;

  public barChartForm!: FormGroup;

  public userId: string;

  constructor(private resultsService: ResultService,
              private accountService: SecurityService,
              private formBuilder: FormBuilder) { }

  public async ionViewWillEnter() {
    this.barChartForm = this.formBuilder.group({
      type: new FormControl('mean', [Validators.required]),
      category: new FormControl('season', [Validators.required])
    });

    this.userId = await this.accountService.getUserId();
    await this.loadChart();
  }

  public async loadChart() {
    this.barChartOption = await this.resultsService.getBarChartOptions(this.barChartForm.controls.category.value, this.barChartForm.controls.type.value, this.userId);
    this.scatterPlotOption = await this.resultsService.getScatterPlotOptions();
  }
}
